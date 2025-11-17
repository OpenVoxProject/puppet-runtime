# frozen_string_literal: true

require 'rake'
require 'json'
require 'uri'
require 'net/http'
require 'rubygems/version'
require 'rubygems/requirement'
require 'open3'

REPO_ROOT      = File.expand_path('..', __dir__)
COMPONENT_DIR  = File.join(REPO_ROOT, 'configs', 'components')
COMPONENT_GLOB = File.join(COMPONENT_DIR, 'rubygem-*.rb')
PROJECT_GLOB   = File.join(REPO_ROOT, 'configs', 'projects', '*.rb')

MAINT_START    = /^\s*### Maintained by update_gems automation ###\s*$/
MAINT_END      = /^\s*### End automated maintenance section ###\s*$/
PINNED_LINE    = /^\s*#\s*PINNED\b.*$/
VER_LINE       = /^\s*pkg\.version\s+['"](?<version>[^'"]+)['"]\s*$/
SHA_LINE       = /^\s*pkg\.(?:sha256sum|md5sum)\s+['"](?<sha>[0-9a-fA-F]+)['"]\s*$/
BUILD_REQ      = /^\s*pkg\.build_requires\s+['"]rubygem-([^'"]+)['"]\s*$/
GEM_TYPE       = /^\s*#\s*GEM\s+TYPE:\s*(?<platform>[A-Za-z0-9\-_\.]+)\s*$/
PROJ_COMPONENT = /^\s*proj\.component\s+(?<quote>['"]?)(?<component>rubygem-[^'"\s]+)\k<quote>\s*$/

TARGET_RUBY_VER = ENV['TARGET_RUBY']&.strip || '3.2'
MAX_TABLE_WIDTH = 140
VERSIONS_CACHE  = {}

def git_relative_path(path)
  path = File.expand_path(path)
  prefix = REPO_ROOT + File::SEPARATOR
  path.start_with?(prefix) ? path[prefix.length..-1] : path
end

def git_commit_file(path, message)
  rel = git_relative_path(path)
  status_out, status_err, status_ok = Open3.capture3(
    'git', '-C', REPO_ROOT, 'status', '--porcelain', '--', rel
  )
  unless status_ok
    $stderr.puts "git status failed for #{rel}:\n#{status_err}\n#{status_out}"
    return false
  end
  return true if status_out.strip.empty?

  _, add_err, add_ok = Open3.capture3('git', '-C', REPO_ROOT, 'add', rel)
  unless add_ok
    $stderr.puts "git add failed for #{rel}:\n#{add_err}"
    return false
  end

  _, commit_err, commit_ok = Open3.capture3('git', '-C', REPO_ROOT, 'commit', '-m', message)
  unless commit_ok
    $stderr.puts "git commit failed for #{rel}:\n#{commit_err}"
    return false
  end
  true
end

def color_status(s)
  require 'colorize'
  case s
  when 'UP TO DATE' then s.green
  when 'UPDATED'    then s.yellow
  when 'ADDED'      then s.cyan
  when 'ERROR', 'UNKNOWN' then s.red
  else s
  end
end

def print_table(headers, rows)
  require 'tty-table'
  comp_w, status_w, version_w = 50, 12, 32
  deps_w = [MAX_TABLE_WIDTH - (comp_w + status_w + version_w + 13), 10].max
  table = TTY::Table.new headers, rows
  puts table.render(:ascii, width: MAX_TABLE_WIDTH, resize: true, multiline: true, padding: [0,1,0,1]) { |r|
    r.alignments = [:left, :center, :left, :left]
    r.border.separator = :each_row
    r.column_widths = [comp_w, status_w, version_w, deps_w]
  }
end

@progress_max_width = 0
def progress_print(msg, io: $stderr)
  clean = msg[0, MAX_TABLE_WIDTH - 1]
  @progress_max_width = [@progress_max_width, clean.length].max
  io.print("\r#{clean.ljust(@progress_max_width)}")
  io.flush
end

def progress_clear(io: $stderr)
  return if @progress_max_width <= 0
  io.print("\r#{' ' * @progress_max_width}\r")
  io.flush
  @progress_max_width = 0
end

def http(url)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |h|
    r = Net::HTTP::Get.new(uri)
    r['User-Agent'] = 'openvox-runtime-script/1.0'
    res = h.request(r)
    raise "HTTP #{res.code} #{uri}" unless res.is_a?(Net::HTTPSuccess)
    res.body
  end
end

def get_versions(name)
  VERSIONS_CACHE[name] ||= JSON.parse(http("https://rubygems.org/api/v1/versions/#{name}.json"))
end

def get_version_details(name, version)
  enc = URI.encode_www_form_component(version.to_s)
  JSON.parse(http("https://rubygems.org/api/v2/rubygems/#{name}/versions/#{enc}.json"))
end

def ruby_req_ok?(req_str)
  req = req_str.to_s.strip
  req = '>= 0' if req.empty?
  Gem::Requirement.new(req.split(',').map!(&:strip))
                  .satisfied_by?(Gem::Version.new(TARGET_RUBY_VER))
end

def find_sha(name, version, platform)
  metadata = get_versions(name).find { |v| v['number'] == version && v['platform'] == platform }
  raise "Version #{version} (platform: #{platform}) not found for gem #{name}" unless metadata
  raise "SHA not found in metadata for gem #{name} version #{version} platform #{platform}" unless metadata['sha']
  metadata['sha']
end

def get_metadata(name:, version: nil, platforms: ['ruby'])
  all = get_versions(name)
  raise "No versions found for gem #{name}" if all.empty?

  new_version = version
  unless new_version
    candidates = all.select do |v|
      next false if v['prerelease'] || v['yanked']
      next false unless v['platform'].nil? || v['platform'] == 'ruby'
      ruby_req_ok?(v['ruby_version'])
    end
    raise "No compatible versions found for gem #{name}" if candidates.empty?
    new_version = candidates.max_by { |v| Gem::Version.new(v['number']) }['number']
  end

  platforms = platforms.compact.uniq
  shas = {}
  platforms.each { |platform| shas[platform] = find_sha(name, new_version, platform) }

  details = get_version_details(name, new_version)
  deps = (details.dig('dependencies', 'runtime') || [])

  { 'version' => new_version, 'shas' => shas, 'dependencies' => deps }
end

def process_component(path, gemname)
  lines = File.read(path, encoding: 'UTF-8').lines

  start = lines.index { |l| l =~ MAINT_START } or raise "Automated maintenance section not found in #{path}"
  end_rel = lines[(start + 1)..].to_a.index { |l| l =~ MAINT_END } or raise "Automated maintenance section not closed in #{path}"
  finish = start + 1 + end_rel

  body = lines[(start + 1)...finish]
  old_body_str = body.join

  pinned = false
  current_version = nil
  old_deps = []
  platforms = ['ruby']
  prev = nil
  body.each do |line|
    if (m = line.match(VER_LINE))
      current_version = m[:version]
      pinned = !!(prev && prev =~ PINNED_LINE)
    elsif (m = line.match(BUILD_REQ))
      old_deps << m[1]
    elsif (m = line.match(GEM_TYPE))
      platforms << m[:platform]
    end
    prev = line
  end
  platforms.uniq!
  raise "pkg.version not found in maintenance section for #{path}" unless current_version

  metadata = get_metadata(name: gemname, version: pinned ? current_version : nil, platforms: platforms)
  target_version = metadata['version']
  shas = metadata['shas']
  new_deps = metadata['dependencies'].map { |d| d['name'] }.uniq.sort - [gemname]
  newly_added = new_deps - old_deps

  new_body = []
  current_platform = nil
  body.each do |l|
    if (m = l.match(VER_LINE))
      new_body << l.sub(m[:version], target_version)
    elsif (m = l.match(GEM_TYPE))
      current_platform = m[:platform]
      new_body << l
    elsif (m = l.match(SHA_LINE))
      platform = current_platform || 'ruby'
      raise "No SHA found for platform #{platform} of gem #{gemname}" unless shas[platform]
      new_body << l.sub('md5sum', 'sha256sum').sub(m[:sha], shas[platform])
      current_platform = nil
    elsif l =~ BUILD_REQ
      next
    else
      new_body << l
    end
  end

  new_deps.each { |name| new_body << "  pkg.build_requires 'rubygem-#{name}'\n" }

  new_body_str = new_body.join
  block_changed = old_body_str != new_body_str
  lines[(start + 1)...finish] = new_body if block_changed
  version_changed = current_version != target_version

  File.write(path, lines.join, encoding: 'UTF-8') if block_changed

  status = (version_changed || newly_added.any? || block_changed) ? 'UPDATED' : 'UP TO DATE'
  ver_col = version_changed ? "#{current_version} -> #{target_version}" : ''
  missing = new_deps.select { |name| !File.exist?(File.join(COMPONENT_DIR, "rubygem-#{name}.rb")) }

  {
    name:          gemname,
    status:        status,
    version:       ver_col,
    deps_added:    newly_added.map { |n| "rubygem-#{n}" },
    missing:       missing,
    path:          path,
    old_version:   current_version,
    new_version:   target_version,
    block_changed: block_changed
  }
end

def update_projects_for_added(gem, added)
  changed_files = []
  Dir[PROJECT_GLOB].each do |proj_path|
    lines = File.read(proj_path, encoding: 'UTF-8').lines
    next if lines.any? { |l| (m = l.match(PROJ_COMPONENT)) && m[:component] == added }

    gem_index = nil
    gem_indent = '  '
    lines.each_with_index do |l, i|
      if (m = l.match(PROJ_COMPONENT)) && m[:component] == gem
        gem_index = i
        gem_indent = (l[/^\s*/] || '  ')
        break
      end
    end
    next unless gem_index

    lines.insert(gem_index + 1, "#{gem_indent}proj.component '#{added}'\n")
    File.write(proj_path, lines.join, encoding: 'UTF-8')
    changed_files << proj_path
  end
  changed_files
end

def create_component_file(path, gemname, version, sha, deps = [])
  deps_block = deps.map { |name| "  pkg.build_requires 'rubygem-#{name}'\n" }.join
  content = <<~RUBY
    #####
    # Component release information:
    #   https://rubygems.org/gems/#{gemname}
    #####
    component 'rubygem-#{gemname}' do |pkg, settings, platform|
      ### Maintained by update_gems automation ###
      pkg.version '#{version}'
      pkg.sha256sum '#{sha}'
  RUBY
  content << deps_block
  content << <<~RUBY
      ### End automated maintenance section ###

      instance_eval File.read('configs/components/_base-rubygem.rb')
    end
  RUBY
  File.write(path, content, encoding: 'UTF-8')
end

def update_all_components_and_projects
  results = []
  added   = []

  files = Dir[COMPONENT_GLOB]
  total = files.length

  files.each_with_index do |path, i|
    basename = File.basename(path, '.rb')
    gemname  = basename.sub(/^rubygem-/, '')
    progress_print("Processing (#{i + 1}/#{total}): #{basename}")
    r = process_component(path, gemname)
    results << r

    next unless r[:block_changed]
    component = "rubygem-#{r[:name]}"
    msg =
      if r[:old_version] != r[:new_version]
        "#{component}: Update #{r[:old_version]} -> #{r[:new_version]}"
      elsif !r[:deps_added].empty?
        if r[:deps_added].length == 1
          dep = r[:deps_added].first
          "#{component}: Add #{dep} dependency"
        else
          deps = r[:deps_added].join(', ')
          "#{component}: Add dependencies #{deps}"
        end
      else
        "#{component}: Update component metadata"
      end
    git_commit_file(r[:path], msg)
  end
  progress_clear

  queue = results.flat_map { |r| (r[:missing] || []).map { |dep| [r[:name], dep] } }

  until queue.empty?
    existing_gem, added_dep = queue.shift
    dep_path = File.join(COMPONENT_DIR, "rubygem-#{added_dep}.rb")
    created = false
    deps = nil

    unless File.exist?(dep_path)
      progress_print("Creating component #{added_dep} (required by #{existing_gem})")
      m    = get_metadata(name: added_dep, platforms: ['ruby'])
      ver  = m['version']
      sha  = m['shas']['ruby']
      deps = (m['dependencies'] || []).map { |d| d['name'] }.uniq.sort - [added_dep]

      create_component_file(dep_path, added_dep, ver, sha, deps)
      added << { name: added_dep, version: ver, deps: deps, path: dep_path }

      component_full_name = "rubygem-#{added_dep}"
      git_commit_file(dep_path, "#{component_full_name}: Add new component")
      created = true
    end

    if created || added.any? { |g| g[:name] == added_dep }
      component_full_name = "rubygem-#{added_dep}"
      update_projects_for_added("rubygem-#{existing_gem}", component_full_name).each do |proj_path|
        project_name = File.basename(proj_path, '.rb')
        git_commit_file(proj_path, "#{project_name}: Add #{component_full_name} component")
      end
    end

    deps&.each do |trans_dep|
      trans_path = File.join(COMPONENT_DIR, "rubygem-#{trans_dep}.rb")
      queue << [added_dep, trans_dep] unless File.exist?(trans_path)
    end
  end

  progress_clear
  [results, added]
end

def output_json(results, added)
  puts JSON.pretty_generate(
    ruby_version_used_for_checks: TARGET_RUBY_VER,
    results: results.map { |r|
      {
        name:       r[:name],
        status:     r[:status],
        version:    r[:version],
        deps_added: r[:deps_added],
        missing:    r[:missing]
      }
    },
    added: added.map { |info|
      { name: info[:name], version: info[:version], deps: info[:deps] }
    }
  )
end

def output_table(results, added)
  headers = ['Component', 'Status', 'Version update', 'Dependencies added']
  rows = results.map do |r|
    [
      "rubygem-#{r[:name]}",
      color_status(r[:status]),
      r[:version],
      r[:deps_added].join(', ')
    ]
  end
  added.each do |info|
    rows << [
      "rubygem-#{info[:name]}",
      color_status('ADDED'),
      info[:version].to_s,
      info[:deps].to_a.uniq.sort.map { |dn| "rubygem-#{dn}" }.join(', ')
    ]
  end
  print_table(headers, rows)
end

namespace :vox do
  desc 'Update rubygem components and print a summary table or JSON of changes'
  task :update_gems do
    results, added = update_all_components_and_projects
    if !(ARGV & ['--json', '-j', '--format=json']).empty?
      output_json(results, added)
    else
      output_table(results, added)
    end
  end
end
