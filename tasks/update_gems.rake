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
GEM_TYPE       = /^\s*#\s*GEM\s+TYPE:\s*(?<platform>[A-Za-z0-9\-_.]+)\s*$/
PROJ_COMPONENT = /^\s*proj\.component\s+(?<quote>['"]?)(?<component>rubygem-[^'"\s]+)\k<quote>\s*$/

TARGET_RUBY_VER = ENV['TARGET_RUBY']&.strip || '3.2'
# Update this list when targeting a new Ruby version
DEFAULT_GEMS = [
  'abbrev',
  'base64',
  'benchmark',
  'bigdecimal',
  'bundler',
  'cgi',
  'csv',
  'date',
  'delegate',
  'did_you_mean',
  'digest',
  'drb',
  'english',
  'erb',
  'error_highlight',
  'etc',
  'fcntl',
  'fiddle',
  'fileutils',
  'find',
  'forwardable',
  'getoptlong',
  'io-console',
  'io-nonblock',
  'io-wait',
  'ipaddr',
  'irb',
  'json',
  'logger',
  'mutex_m',
  'net-http',
  'net-protocol',
  'nkf',
  'observer',
  'open3',
  'openssl',
  'open-uri',
  'optparse',
  'ostruct',
  'pathname',
  'pp',
  'prettyprint',
  'pstore',
  'psych',
  'racc',
  'rdoc',
  'readline',
  'readline-ext',
  'reline',
  'resolv',
  'resolv-replace',
  'rinda',
  'ruby2_keywords',
  'rubygems',
  'securerandom',
  'set',
  'shellwords',
  'singleton',
  'stringio',
  'strscan',
  'syslog',
  'syntax_suggest',
  'tempfile',
  'time',
  'timeout',
  'tmpdir',
  'tsort',
  'un',
  'uri',
  'weakref',
  'win32ole',
  'yaml',
  'zlib'
].freeze
@versions_cache = {}

@component_deps    = {} # gem_name => [dep gem names]
@component_changes = [] # changed / created components
@project_component_additions = Hash.new { |h, k| h[k] = [] } # project => [component names added, e.g. "rubygem-foo"]

def component_path(gem_name)
  File.join(COMPONENT_DIR, "rubygem-#{gem_name}.rb")
end

def progress_print(msg, io: $stderr)
  clean = msg[0, 100].ljust(100)
  io.print("\r#{clean}")
  io.flush
end

def progress_clear(io: $stderr)
  io.print("\r#{' ' * 100}\r")
  io.flush
end

def http(url)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |h|
    req = Net::HTTP::Get.new(uri)
    req['User-Agent'] = 'openvox_update_gems/1.0'
    res = h.request(req)
    raise "HTTP #{res.code} #{uri}" unless res.is_a?(Net::HTTPSuccess)

    res.body
  end
end

def get_versions(name)
  @versions_cache[name] ||= JSON.parse(http("https://rubygems.org/api/v1/versions/#{name}.json"))
end

def get_version_details(name, version)
  enc = URI.encode_www_form_component(version.to_s)
  JSON.parse(http("https://rubygems.org/api/v2/rubygems/#{name}/versions/#{enc}.json"))
end

def ruby_req_ok?(req_str)
  req = req_str.to_s.strip
  req = '>= 0' if req.empty?
  Gem::Requirement
    .new(req.split(',').map!(&:strip))
    .satisfied_by?(Gem::Version.new(TARGET_RUBY_VER))
end

def find_sha(name, version, platform)
  metadata = get_versions(name).find { |v| v['number'] == version && v['platform'] == platform }
  raise "Version #{version} (platform: #{platform}) not found for gem #{name}" unless metadata
  raise "SHA not found in metadata for gem #{name} version #{version} platform #{platform}" unless metadata['sha']

  metadata['sha']
end

def get_metadata(name:, version: nil, platforms: ['ruby'])
  versions = get_versions(name)
  raise "No versions found for gem #{name}" if versions.empty?

  # Only look up latest version if version was not passed in
  version ||= begin
    candidates = versions.select do |v|
      !v['prerelease'] &&
        !v['yanked'] &&
        (v['platform'].nil? || v['platform'] == 'ruby') &&
        ruby_req_ok?(v['ruby_version'])
    end
    raise "No compatible versions found for gem #{name}" if candidates.empty?

    candidates.max_by { |v| Gem::Version.new(v['number']) }['number']
  end

  shas = platforms.to_h { |platform| [platform, find_sha(name, version, platform)] }
  deps = get_version_details(name, version).dig('dependencies', 'runtime') || []
  # Remove any default gems as we don't want to manage them unless specifically needed
  deps.reject! { |d| DEFAULT_GEMS.include?(d['name']) }
  { 'version' => version, 'shas' => shas, 'dependencies' => deps }
end

# Process a single component file, updating its maintenance section as needed.
# Returns an array of gem names for any missing dependency components that need to be created.
def process_component_file(path)
  lines = File.read(path, encoding: 'UTF-8').lines

  start = lines.index { |l| l =~ MAINT_START } or raise "Automated maintenance section not found in #{path}"
  end_rel = lines[(start + 1)..].index { |l| l =~ MAINT_END } or raise "Automated maintenance section not closed in #{path}"
  finish = start + 1 + end_rel
  body   = lines[(start + 1)...finish]

  pinned          = false
  current_version = nil
  current_deps    = []
  platforms       = ['ruby']

  # Scan existing maintenance section for current state
  body.each do |line|
    if (m = line.match(VER_LINE))
      current_version = m[:version]
    elsif line.match?(PINNED_LINE)
      pinned = true
    elsif (m = line.match(BUILD_REQ))
      current_deps << m[1]
    elsif (m = line.match(GEM_TYPE))
      platforms << m[:platform]
    end
  end

  platforms.uniq!
  raise "pkg.version not found in maintenance section for #{path}" unless current_version

  component_name = File.basename(path, '.rb')
  gem_name       = component_name.sub(/^rubygem-/, '')

  metadata       = get_metadata(name: gem_name, version: pinned ? current_version : nil, platforms: platforms)
  target_version = metadata['version']
  shas           = metadata['shas']
  gem_deps       = (metadata['dependencies'] || []).map { |d| d['name'] }.uniq.sort

  @component_deps[gem_name] = gem_deps

  new_body         = []
  current_platform = nil

  # Rebuild maintenance section with updated info. We do replacement
  # this way to preserve any extra comments or formatting.
  body.each do |l|
    if (m = l.match(VER_LINE))
      new_body << l.sub(m[:version], target_version)
    elsif (m = l.match(GEM_TYPE))
      current_platform = m[:platform]
      new_body << l
    elsif (m = l.match(SHA_LINE))
      platform = current_platform || 'ruby'
      sha = shas[platform]
      raise "No SHA found for platform #{platform} of gem #{gem_name}" unless sha

      new_body << l.sub('md5sum', 'sha256sum').sub(m[:sha], sha)
      current_platform = nil
    elsif l =~ BUILD_REQ
      # rebuild build_requires from gem_deps later
      next
    else
      new_body << l
    end
  end

  gem_deps.each { |dep| new_body << "  pkg.build_requires 'rubygem-#{dep}'\n" }

  block_changed = (body != new_body)
  if block_changed
    lines[(start + 1)...finish] = new_body
    File.write(path, lines.join, encoding: 'UTF-8')
  end

  old_deps              = current_deps.uniq.sort
  deps_added_gems       = gem_deps - old_deps
  deps_added_components = deps_added_gems.map { |gem| "rubygem-#{gem}" }

  missing_gems = gem_deps.reject { |gem| File.exist?(component_path(gem)) }

  # Only mark a component as changed if we materially changed something.
  # Ignore sorting of existing dependencies or updating md5 to sha256.
  if current_version != target_version || !deps_added_components.empty?
    @component_changes << {
      name: component_name,
      old_version: current_version,
      new_version: target_version,
      deps_added: deps_added_components
    }
  end

  missing_gems
end

def create_missing_component(gem_name)
  path = component_path(gem_name)

  metadata = get_metadata(name: gem_name, platforms: ['ruby'])
  version  = metadata['version']
  sha      = metadata['shas']['ruby']
  raise "No ruby SHA found for new component rubygem-#{gem_name}" unless sha

  gem_deps = (metadata['dependencies'] || []).map { |d| d['name'] }.uniq.sort

  content = <<~TEXT
    #####
    # Component release information:
    #   https://rubygems.org/gems/#{gem_name}
    #####
    component 'rubygem-#{gem_name}' do |pkg, _settings, _platform|
      ### Maintained by update_gems automation ###
      pkg.version '#{version}'
      pkg.sha256sum '#{sha}'
  TEXT
  content << gem_deps.map { |name| "  pkg.build_requires 'rubygem-#{name}'\n" }.join
  content << <<~TEXT
      ### End automated maintenance section ###

      instance_eval File.read('configs/components/_base-rubygem.rb')
    end
  TEXT
  File.write(path, content, encoding: 'UTF-8')

  @component_deps[gem_name] = gem_deps

  @component_changes << {
    name: "rubygem-#{gem_name}",
    old_version: nil,
    new_version: version,
    deps_added: gem_deps.map { |gem| "rubygem-#{gem}" }
  }

  gem_deps
end

def update_all_components_and_create_missing
  missing_queue   = []
  component_paths = Dir[COMPONENT_GLOB].sort
  total           = component_paths.length

  component_paths.each_with_index do |path, i|
    progress_print("Processing (#{i + 1}/#{total}): #{File.basename(path, '.rb')}")
    missing_queue.concat(process_component_file(path))
  end
  progress_clear

  until missing_queue.empty?
    gem_name = missing_queue.shift
    next if File.exist?(component_path(gem_name))

    progress_print("Creating component rubygem-#{gem_name}")
    create_missing_component(gem_name).each do |dep_gem|
      dep_path = component_path(dep_gem)
      missing_queue << dep_gem if !File.exist?(dep_path) && !missing_queue.include?(dep_gem)
    end
  end
  progress_clear
end

def ensure_projects_have_component_deps
  @project_component_additions = Hash.new { |h, k| h[k] = [] }

  Dir[PROJECT_GLOB].sort.each do |proj_path|
    lines        = File.read(proj_path, encoding: 'UTF-8').lines
    project_name = File.basename(proj_path, '.rb')

    # Map gem_name => line index where its component is declared so
    # that we can insert dependencies after it, in case it is inside
    # a conditional block (e.g. only for Windows platforms).
    components = {}
    lines.each_with_index do |line, idx|
      next unless (m = line.match(PROJ_COMPONENT))

      gem_name = m[:component].sub(/^rubygem-/, '')
      components[gem_name] ||= idx
    end

    @component_deps.each do |gem_name, dep_gems|
      comp_line_index = components[gem_name]
      next unless comp_line_index

      dep_gems.each do |dep_gem|
        next if components.key?(dep_gem) # Project already declares this dep component

        indent       = lines[comp_line_index][/^\s*/]
        insert_index = comp_line_index + 1
        lines.insert(insert_index, "#{indent}proj.component 'rubygem-#{dep_gem}'\n")

        # Shift indices of later components down by one line
        components[dep_gem] = insert_index
        components.each do |comp_gem, idx|
          next if comp_gem == dep_gem

          components[comp_gem] = idx + 1 if idx > comp_line_index
        end

        @project_component_additions[project_name] << "rubygem-#{dep_gem}"
      end
    end

    File.write(proj_path, lines.join, encoding: 'UTF-8') unless @project_component_additions[project_name].empty?
  end
end

def build_summary
  lines = []

  unless @component_changes.empty?
    lines << 'Component updates:'
    @component_changes.sort_by { |c| c[:name] }.each do |c|
      parts = []
      if c[:old_version] && c[:new_version] && c[:old_version] != c[:new_version]
        parts << "version #{c[:old_version]} -> #{c[:new_version]}"
      elsif c[:old_version].nil? && c[:new_version]
        parts << "new component (version #{c[:new_version]})"
      end
      parts << "added deps: #{c[:deps_added].join(', ')}" unless c[:deps_added].empty?
      lines << "- #{c[:name]}: #{parts.join(', ')}" unless parts.empty?
    end
  end

  unless @project_component_additions.none? { |_, v| !v.empty? }
    lines << '' unless lines.empty?
    lines << 'Project component additions:'
    @project_component_additions.keys.sort.each do |project|
      components = @project_component_additions[project].uniq.sort
      lines << "- #{project}: #{components.join(', ')}" unless components.empty?
    end
  end

  lines.join("\n")
end

def git_add
  _, err, ok = Open3.capture3(
    'git', '-C', REPO_ROOT,
    'add', 'configs/components', 'configs/projects'
  )
  warn "git add failed:\n#{err}" unless ok
  ok
end

def git_commit(message)
  out, err, ok = Open3.capture3('git', '-C', REPO_ROOT, 'diff', '--cached', '--name-only')
  warn "git diff --cached failed:\n#{err}\n#{out}" unless ok
  return if !ok || out.strip.empty?

  args = ['git', '-C', REPO_ROOT, 'commit', '-m', 'Update rubygem components']
  args += ['-m', message] unless message.empty?

  _, err, ok = Open3.capture3(*args)
  warn "git commit failed:\n#{err}" unless ok
end

def ensure_no_uncommitted_changes
  out, status = Open3.capture2e(
    'git', '-C', REPO_ROOT,
    'status', '--porcelain', '--',
    'configs/components', 'configs/projects'
  )

  unless status.success?
    warn "git status failed:\n#{out}"
    exit 1
  end

  return if out.strip.empty?

  warn <<~MSG
    Refusing to run: uncommitted changes detected in configs:
    #{out}
    Please commit, stash, or discard these changes before running this task.
  MSG
  exit 1
end

namespace :vox do
  desc 'Update rubygem components and print a summary of changes'
  task :update_gems do
    ensure_no_uncommitted_changes

    progress_print('Updating components and creating missing ones')
    update_all_components_and_create_missing
    progress_clear

    progress_print('Ensuring project component dependencies')
    ensure_projects_have_component_deps
    progress_clear

    summary = build_summary

    if summary.empty?
      puts 'No updates to any rubygem components needed'
      exit 0
    end

    puts summary

    git_add
    git_commit(summary)
  end
end
