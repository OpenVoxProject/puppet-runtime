# frozen_string_literal: true

require 'rake'
require 'json'
require 'uri'
require 'net/http'
require 'rubygems/version'
require 'rubygems/requirement'
require 'set'

# ----- Constants -----
REPO_ROOT      = File.expand_path('..', __dir__)
COMPONENT_DIR  = File.join(REPO_ROOT, 'configs', 'components')
COMPONENT_GLOB = File.join(COMPONENT_DIR, 'rubygem-*.rb')

MAINT_START = /^\s*### Maintained by update_gems automation ###\s*$/
MAINT_END   = /^\s*### End automated maintenance section ###\s*$/
PINNED_LINE = /^\s*#\s*PINNED\b.*$/
VER_LINE    = /^\s*pkg\.version\s+['"](?<version>[^'"]+)['"]\s*$/
SHA_LINE     = /^\s*pkg\.(?:sha256sum|md5sum)\s+['"](?<sha>[0-9a-fA-F]+)['"]\s*$/
BUILD_REQ   = /^\s*pkg\.build_requires\s+['"]rubygem-([^'"]+)['"]\s*$/
GEM_TYPE    = /^\s*#\s*GEM\s+TYPE:\s*(?<platform>[A-Za-z0-9\-_\.]+)\s*$/

TARGET_RUBY_VER = ENV['TARGET_RUBY']&.strip || '3.2'
MAX_TABLE_WIDTH = 140
VERSIONS_CACHE  = {}

def create_component_file(path, gemname, version, sha, deps = [])
  lines = []
  lines << "#####\n"
  lines << "# Component release information:\n"
  lines << "#   https://rubygems.org/gems/#{gemname}\n"
  lines << "#####\n"
  lines << "component 'rubygem-#{gemname}' do |pkg, settings, platform|\n"
  lines << "  ### Maintained by update_gems automation ###\n"
  lines << "  pkg.version '#{version}'\n"
  lines << "  pkg.sha256sum '#{sha}'\n"
  deps.each { |name| lines << "  pkg.build_requires 'rubygem-#{name}'\n" }
  lines << "  ### End automated maintenance section ###\n"
  lines << "\n"
  lines << "  instance_eval File.read('configs/components/_base-rubygem.rb')\n"
  lines << "end\n"
  File.write(path, lines.join, encoding: 'UTF-8')
end

# ----- Table and progress output -----
def color_status(s)
  # Put this here so that things don't blow up for other tasks
  # if the development bundle isn't installed.
  require 'colorize'
  case s
  when 'UP TO DATE' then s.green
  when 'UPDATED'    then s.yellow
  when 'ADDED'      then s.cyan
  when 'ERROR'      then s.red
  when 'UNKNOWN'    then s.red
  else s
  end
end

def print_table(headers, rows)
  # Put this here so that things don't blow up for other tasks
  # if the development bundle isn't installed.
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

# ----- Rubygems API access -----
def http(url)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |h|
    r = Net::HTTP::Get.new(uri)
    r['User-Agent'] = "openvox-runtime-script/1.0"
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

# ----- Fetching gem metadata -----
def ruby_req_ok?(req_str)
  req = (req_str.nil? || req_str.strip.empty?) ? '>= 0' : req_str
  req = req.split(',').map(&:strip)
  Gem::Requirement.new(req).satisfied_by?(Gem::Version.new(TARGET_RUBY_VER))
end

def find_sha(name, version, platform)
  # The v2 API only returns SHA for the "ruby" platform
  if platform.nil? || platform == '' || platform == 'ruby'
    details = get_version_details(name, version)
    raise "SHA not found in details for gem #{name} version #{version}" unless details['sha']
    return details['sha']
  end

  # Otherwise, use the v1 API to find the specific platform
  list = get_versions(name)
  metadata = list.find { |v| v['number'] == version && v['platform'] == platform }
  raise "Version #{version} (platform: #{platform}) not found for gem #{name}" unless metadata
  raise "SHA not found in metadata for gem #{name} version #{version} platform #{platform}" unless metadata['sha']
  metadata['sha']
end

def get_metadata(name:, version: nil, platforms: ['ruby'])
  all = get_versions(name)
  raise "No versions found for gem #{name}" if all.empty?

  # Choose version, either the one passed in, or the latest compatible
  new_version = version
  unless new_version
    candidates = all.select do |v|
      next false if v['prerelease']
      next false if v['yanked']
      next false unless v['platform'].nil? || v['platform'] == 'ruby'
      ruby_req_ok?(v['ruby_version'])
    end
    raise "No compatible versions found for gem #{name}" if candidates.empty?
    new_version = candidates.max_by { |v| Gem::Version.new(v['number']) }['number']
  end

  # Gather SHAs for requested platforms
  platforms = platforms.compact.uniq
  shas = {}
  platforms.each do |platform|
    shas[platform] = find_sha(name, new_version, platform)
  end

  details = get_version_details(name, new_version)
  deps = (details.dig('dependencies', 'runtime') || [])

  { 'version' => new_version, 'shas' => shas, 'dependencies' => deps }
end

# ----- Processing component files -----
def process_component(path, gemname)
  lines = File.read(path, encoding: 'UTF-8').lines

  # Find maintenance block
  start = lines.index { |l| l =~ MAINT_START } or raise "Automated maintenance section not found in #{path}"
  end_rel = lines[(start + 1)..].to_a.index { |l| l =~ MAINT_END } or raise "Automated maintenance section not closed in #{path}"
  finish = start + 1 + end_rel

  body = lines[(start + 1)...finish]
  old_body_str = body.join

  # First pass: read current version, pinned, deps, and platforms
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
  raise "pkg.version not found in maintenance section for #{path}" unless current_version

  # Resolve target version, shas, and deps
  metadata = get_metadata(name: gemname, version: pinned ? current_version : nil, platforms: platforms.uniq)
  target_version = metadata['version']
  shas = metadata['shas']
  new_deps = metadata['dependencies'].map { |d| d['name'] }.uniq.sort - [gemname]
  newly_added = new_deps - old_deps

  # Generate new block body
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
      # Drop existing build_requires
      next
    else
      new_body << l
    end
  end

  # Append new build_requires at end of block body
  new_deps.each { |name| new_body << "  pkg.build_requires 'rubygem-#{name}'\n" }

  new_body_str = new_body.join
  block_changed = (old_body_str != new_body_str)
  lines[(start + 1)...finish] = new_body if block_changed

  version_changed = (current_version != target_version)

  File.write(path, lines.join, encoding: 'UTF-8') if block_changed

  status = (version_changed || newly_added.any? || block_changed) ? 'UPDATED' : 'UP TO DATE'
  ver_col = version_changed ? "#{current_version} -> #{target_version}" : ''

  # Report missing components so the task can create them
  missing = new_deps.select { |name| !File.exist?(File.join(COMPONENT_DIR, "rubygem-#{name}.rb")) }

  { name: gemname, status: status, version: ver_col, deps_added: newly_added.map { |n| "rubygem-#{n}" }, missing: missing }
end


namespace :vox do
  desc 'Update rubygem components and print a summary table or JSON of changes'
  task :update_gems do
    results = []
    files = Dir.glob(COMPONENT_GLOB).select { |p| File.file?(p) }
    total = files.length

    files.each_with_index do |path, i|
      basename = File.basename(path, '.rb')
      gemname  = basename.sub(/^rubygem-/, '')
      progress_print("Processing (#{i + 1}/#{total}): #{basename}")
      results << process_component(path, gemname)
    end
    progress_clear

    # Create missing component files after processing all
    # Because some of the added components may have runtime
    # dependencies themselves that are also missing, we need
    # to keep a running queue of missing components to add.
    added = []
    queue = results.flat_map { |r| r[:missing] || [] }.uniq
    seen = Set.new
    until queue.empty?
      name = queue.shift
      next if seen.include?(name)
      seen << name

      progress_print("Creating component for missing gem: #{name}")

      path = File.join(COMPONENT_DIR, "rubygem-#{name}.rb")
      next if File.exist?(path)

      m = get_metadata(name: name, platforms: ['ruby'])
      ver  = m['version']
      sha  = m['shas']['ruby']
      deps = (m['dependencies'] || []).map { |d| d['name'] }.uniq.sort - [name]

      create_component_file(path, name, ver, sha, deps)
      added << { name: name, version: ver, deps: deps }

      deps.each do |name|
        path = File.join(COMPONENT_DIR, "rubygem-#{name}.rb")
        queue << name unless File.exist?(path) || seen.include?(name) || queue.include?(name)
      end
    end
    progress_clear

    # JSON output
    if !(ARGV & ['--json', '-j', '--format=json']).empty?
      payload = {
        ruby_version_used_for_checks: TARGET_RUBY_VER,
        results: results,
        added: added,
      }
      puts JSON.pretty_generate(payload)
      next
    end

    # Table output
    headers = ['Component', 'Status', 'Version update', 'Dependencies added']
    rows = results.map do |r|
      [
        "rubygem-#{r[:name]}",
        color_status(r[:status]),
        r[:version],
        r[:deps_added].join(', '),
      ]
    end
    added.each do |info|
      rows << [
        "rubygem-#{info[:name]}",
        color_status('ADDED'),
        info[:version].to_s,
        info[:deps].to_a.uniq.sort.map { |dn| "rubygem-#{dn}" }.join(', '),
      ]
    end
    print_table(headers, rows)
  end
end