# frozen_string_literal: true

require 'rake'
require 'json'
require 'uri'
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

TARGET_RUBY_VER = ENV['TARGET_RUBY']&.strip || '4.0'
# Update this list when targeting a new Ruby version. Comment out
# gems that we specifically want to manage even if they are default or bundled.
DEFAULT_AND_BUNDLED_GEMS = [
  'abbrev',
  'base64',
  'benchmark',
  'bigdecimal',
  'bundler',
  'csv',
  'date',
  'debug',
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
  'matrix',
  'minitest',
  'mutex_m',
  'net-ftp',
  'net-http',
  'net-imap',
  'net-pop',
  'net-protocol',
  'net-smtp',
  'nkf',
  'observer',
  'open3',
  'openssl',
  'open-uri',
  'optparse',
  'ostruct',
  # Core class since Ruby 4.0, kept so a dependency on the gem creates no component.
  'pathname',
  'power_assert',
  'pp',
  'prettyprint',
  'prime',
  'prism',
  'pstore',
  'psych',
  'racc',
  'rake',
  'rbs',
  'rdoc',
  'readline',
  'reline',
  'repl_type_completor',
  'resolv',
  'resolv-replace',
  # 'rexml',
  'rinda',
  'rss',
  'ruby2_keywords',
  'rubygems',
  'securerandom',
  # Core class since Ruby 4.0, kept so a dependency on the gem creates no component.
  'set',
  'shellwords',
  'singleton',
  'stringio',
  'strscan',
  'syntax_suggest',
  'syslog',
  'tempfile',
  'test-unit',
  'time',
  'timeout',
  'tmpdir',
  'tsort',
  'typeprof',
  'un',
  'uri',
  'weakref',
  'win32-registry',
  'win32ole',
  'yaml',
  'zlib'
].freeze
@versions_cache = {}

@components        = {} # gem_name => component state, see new_component
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

def get_metadata(name:, version: nil, platforms: ['ruby'], requirement: nil)
  versions = get_versions(name)
  raise "No versions found for gem #{name}" if versions.empty?

  # Only look up latest version if version was not passed in
  version ||= begin
    candidates = versions.select do |v|
      !v['prerelease'] &&
        !v['yanked'] &&
        (v['platform'].nil? || v['platform'] == 'ruby') &&
        ruby_req_ok?(v['ruby_version']) &&
        (requirement.nil? || requirement.satisfied_by?(Gem::Version.new(v['number'])))
    end
    if candidates.empty?
      wanted = requirement ? " matching #{requirement}" : ''
      raise "No compatible versions found for gem #{name}#{wanted}"
    end

    candidates.max_by { |v| Gem::Version.new(v['number']) }['number']
  end

  shas = platforms.to_h { |platform| [platform, find_sha(name, version, platform)] }
  details = get_version_details(name, version)
  deps = details.dig('dependencies', 'runtime') || []
  # Remove any default gems as we don't want to manage them unless specifically needed
  deps.reject! { |d| DEFAULT_AND_BUNDLED_GEMS.include?(d['name']) }

  {
    'version' => version,
    'shas' => shas,
    'dependencies' => deps,
    'changelog_uri' => details['changelog_uri'],
    'source_code_uri' => details['source_code_uri']
  }
end

# State for a component that has no file yet. read_component adds the file
# contents and what its maintenance section currently says.
def new_component(gem_name)
  {
    gem_name: gem_name,
    component_name: "rubygem-#{gem_name}",
    path: component_path(gem_name),
    pinned: false,
    current_version: nil,
    current_deps: [],
    platforms: ['ruby']
  }
end

# Reads a component file and what its maintenance section currently says.
def read_component(path)
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

  new_component(gem_name).merge(lines: lines, start: start, finish: finish, body: body, pinned: pinned,
                                current_version: current_version, current_deps: current_deps, platforms: platforms)
end

# A pinned component keeps its version. Any other gets the newest release
# that fits the target Ruby and, when given, the requirement.
def resolve_component(component, requirement: nil)
  component[:metadata] = get_metadata(name: component[:gem_name],
                                      version: component[:pinned] ? component[:current_version] : nil,
                                      platforms: component[:platforms],
                                      requirement: requirement)
end

def describe_dependents(dependents)
  dependents.map { |gem_name, requirements| "#{gem_name} requires #{requirements}" }.join(' and ')
end

# Creates the components that dependencies are missing and lowers any
# dependency that a dependent cannot use to the newest version all of its
# dependents accept. A lowered version may change what that gem depends
# on, so this repeats until nothing moves.
def resolve_dependencies
  loop do
    changed = false
    dependency_gems = @components.values.flat_map { |c| c[:metadata]['dependencies'].map { |d| d['name'] } }.uniq.sort

    dependency_gems.each do |gem_name|
      # Each dependent as [gem name, requirement string], then all of them as one requirement
      dependents = @components.values.flat_map do |dependent|
        dependent[:metadata]['dependencies'].select { |d| d['name'] == gem_name }
                                            .map { |d| [dependent[:gem_name], d['requirements']] }
      end
      requirement = Gem::Requirement.new(dependents.flat_map { |_, requirements| requirements.split(',').map(&:strip) })
      component   = @components[gem_name]

      if component.nil?
        progress_print("Creating component rubygem-#{gem_name}")
        component = new_component(gem_name)
        @components[gem_name] = component
        resolve_component(component, requirement: requirement)
      elsif requirement.satisfied_by?(Gem::Version.new(component[:metadata]['version']))
        next
      elsif component[:pinned]
        raise "#{component[:component_name]} is pinned at #{component[:metadata]['version']} but #{describe_dependents(dependents)}"
      else
        newest = component[:held_from] || component[:metadata]['version']
        resolve_component(component, requirement: requirement)
        component[:held_from] = newest
        component[:held_by]   = dependents.reject do |_, requirements|
          Gem::Requirement.new(requirements.split(',').map(&:strip)).satisfied_by?(Gem::Version.new(newest))
        end
      end

      changed = true
    end

    break unless changed
  end
end

# Rewrites the maintenance section of an existing component file from the resolved metadata.
def process_component_file(component)
  path, lines, start, finish, body = component.values_at(:path, :lines, :start, :finish, :body)
  current_version, current_deps    = component.values_at(:current_version, :current_deps)
  gem_name, component_name         = component.values_at(:gem_name, :component_name)

  metadata       = component[:metadata]
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

  # Only mark a component as changed if we materially changed something.
  # Ignore sorting of existing dependencies or updating md5 to sha256.
  return if current_version == target_version && deps_added_components.empty?

  @component_changes << {
    name: component_name,
    old_version: current_version,
    new_version: target_version,
    deps_added: deps_added_components
  }
end

def create_missing_component(component)
  gem_name, path = component.values_at(:gem_name, :path)

  metadata = component[:metadata]
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
end

def update_all_components_and_create_missing
  component_paths = Dir[COMPONENT_GLOB].sort
  total           = component_paths.length

  component_paths.each_with_index do |path, i|
    progress_print("Processing (#{i + 1}/#{total}): #{File.basename(path, '.rb')}")
    component = read_component(path)
    resolve_component(component)
    @components[component[:gem_name]] = component
  end
  progress_clear

  resolve_dependencies
  progress_clear

  @components.each_value do |component|
    component[:lines] ? process_component_file(component) : create_missing_component(component)
  end
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

# Use published metadata first, then release links already documented in the component.
# Do not guess repository paths or version tags when no changelog is provided.
def component_release_link(component)
  metadata = component[:metadata]
  header_links = []
  candidates = [['Changelog', metadata['changelog_uri']]]

  (component[:lines] || []).each do |line|
    break if line.start_with?('component ')

    url = line[/^#\s+(https?:\/\/\S+)\s*$/, 1]
    header_links << url if url
  end

  header_links.each do |url|
    label = case URI.parse(url).path
            when %r{/(?:changelog|changes|history)(?:[./]|$)}i then 'Changelog'
            when %r{/releases(?:/|$)} then 'Releases'
            when %r{/tags(?:/|$)} then 'Tags'
            end

    candidates << [label, url] if label
  end

  candidates << ['Source', metadata['source_code_uri']]
  candidates << ['RubyGems', "https://rubygems.org/gems/#{component[:gem_name]}/versions/#{metadata['version']}"]

  label, url = candidates.find do |_, candidate|
    uri = URI.parse(candidate.to_s)
    %w[http https].include?(uri.scheme) && uri.host
  rescue URI::InvalidURIError
    false
  end

  "[#{label}](<#{url}>)"
end

def build_summary(markdown: false)
  lines = []

  unless @component_changes.empty?
    lines << 'Component updates:'
    lines << '' if markdown
    @component_changes.sort_by { |c| c[:name] }.each do |c|
      parts = []
      if c[:old_version] && c[:new_version] && c[:old_version] != c[:new_version]
        parts << "version #{c[:old_version]} -> #{c[:new_version]}"
      elsif c[:old_version].nil? && c[:new_version]
        parts << "new component (version #{c[:new_version]})"
      end
      parts << "added deps: #{c[:deps_added].join(', ')}" unless c[:deps_added].empty?
      parts << component_release_link(@components.fetch(c[:name].delete_prefix('rubygem-'))) if markdown
      lines << "- #{c[:name]}: #{parts.join(', ')}" unless parts.empty?
    end
  end

  unless @project_component_additions.none? { |_, v| !v.empty? }
    lines << '' unless lines.empty?
    lines << 'Project component additions:'
    lines << '' if markdown
    @project_component_additions.keys.sort.each do |project|
      components = @project_component_additions[project].uniq.sort
      lines << "- #{project}: #{components.join(', ')}" unless components.empty?
    end
  end

  held = @components.values.select { |c| c[:held_from] }.sort_by { |c| c[:component_name] }
  unless held.empty?
    lines << '' unless lines.empty?
    lines << 'Held back by dependents:'
    lines << '' if markdown
    held.each do |c|
      lines << "- #{c[:component_name]}: #{c[:held_from]} available, kept at #{c[:metadata]['version']} because #{describe_dependents(c[:held_by])}"
    end
  end

  lines.join("\n")
end

# Keep the generated PR description outside the checkout so it is not committed.
# This is optional for local runs and is written even when there are no updates.
def write_pr_body
  path = ENV['COMPONENT_UPDATE_BODY']
  return if path.nil? || path.empty?

  summary = build_summary(markdown: true)
  summary = 'No updates to any rubygem components needed' if summary.empty?
  File.write(path, "Automated gem update task\n\n#{summary}\n", encoding: 'UTF-8')
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

  args = ['git', '-C', REPO_ROOT, 'commit', '-s', '-m', 'Update rubygem components']
  args += ['-m', message] unless message.empty?

  _, err, ok = Open3.capture3(*args)
  warn "git commit failed:\n#{err}" unless ok
end

def git_summary
  out, err, ok = Open3.capture3('git', '-C', REPO_ROOT, 'log', '--name-status', 'HEAD^..HEAD')
  return if !ok || out.strip.empty?

  puts "\nCongratulations, you have authored a new git commit!"
  puts out
  puts err if err
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

def check_and_summarize(commit: true)
  ensure_no_uncommitted_changes

  progress_print('Updating components and creating missing ones')
  update_all_components_and_create_missing
  progress_clear

  progress_print('Ensuring project component dependencies')
  ensure_projects_have_component_deps
  progress_clear

  summary = build_summary
  puts summary unless summary.empty?
  write_pr_body

  if @component_changes.empty? && @project_component_additions.values.all?(&:empty?)
    puts 'No updates to any rubygem components needed'
    exit 0
  end

  return unless commit

  git_add
  git_commit(summary)
  git_summary
end
namespace :vox do
  desc 'Update rubygem components, commit them and print a summary of changes'
  task :update_gems do
    check_and_summarize(commit: true)
  end
  desc 'Update rubygem components, commit them and print a summary of changes'
  task :update_gems_wo_commit do
    check_and_summarize(commit: false)
  end
end
