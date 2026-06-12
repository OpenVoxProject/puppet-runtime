class Version
  attr_reader :date, :x, :raw

  def initialize(value)
    @raw = value

    if (m = value.match(%r{\A(?<date>\d{4}[-|.]\d{2}[-|.]\d{2})[-|.](?<x>\d+)\z}))
      @date = m['date']
      @x = m['x'].to_i
    else
      @date = nil
      @x = 1
    end
  end

  def self.load_from_changelog
    changelog = File.expand_path('../CHANGELOG.md', __dir__)
    version = File.read(changelog).match(/^## \[([^\]]+)\]/) { |match| match[1] }
    version = version.gsub('-', '.')
    new(version)
  rescue Errno::ENOENT
    new('')
  end

  def to_s
    if malformed?
      raw
    else
      "#{date}.#{x}"
    end
  end

  def next!
    if date == today
      @x += 1
    else
      @date = today
      @x = 1
    end

    self
  end

  private

  def malformed?
    date.nil?
  end

  def today
    Time.now.strftime('%Y.%m.%d')
  end
end

def build_component_change_lines(prev_data, new_data, include_project_component_additions: true)
  header_lines = ["\n**Component Changes:**\n", "| Component | Old Version | New Version |\n", "|-----------|-------------|-------------|\n"]
  component_lines = []
  new_components = []

  new_data['components'].sort.each do |comp, ver|
    prev_ver = prev_data['components'][comp]
    next if prev_ver == ver

    new_components << comp if prev_ver.nil?
    component_lines << "| #{comp} | #{prev_ver} | #{ver} |\n"
  end
  component_lines = header_lines + component_lines unless component_lines.empty?

  if include_project_component_additions && !new_components.empty?
    component_lines << "\n**Project component additions:**\n"
    new_components.each do |component|
      projects = new_data['projects']
                 .select { |_, platforms| platforms.values.any? { |components| components.key?(component) } }
                 .keys
      component_lines << "- #{component}: #{projects.join(', ')}\n"
    end
  end

  component_lines
end

desc 'Set the full version of the project'
task 'vox:version:bump:full' do
  puts 'This project use the current date as version number.  No bump needed.'
end

desc 'Get the current version of the project'
task 'vox:version:current' do
  puts Version.load_from_changelog
end

desc 'Get the next version of the project'
task 'vox:version:next' do
  puts Version.load_from_changelog.next!
end

# rubocop:disable Rake/DuplicateTask
begin
  gem 'github_changelog_generator'
rescue Gem::LoadError
  task :changelog, [:future_release] do
    abort('Run `bundle install --with release` to install the `github_changelog_generator` gem.')
  end
else
  desc 'Generate/update CHANGELOG.md from GitHub issues/PRs'
  task :changelog, [:future_release] do |_, args|
    future_release = args[:future_release] or abort 'You must provide the future release version, e.g. rake "changelog[2025.02.12.1]"'

    header = <<~HEADER.chomp
      # Changelog
      All notable changes to this project will be documented in this file.
    HEADER

    changelog_path = File.expand_path('../CHANGELOG.md', __dir__)

    cmd = %W[
      bundle exec github_changelog_generator
      --user openvoxproject
      --project puppet-runtime
      --exclude-labels dependencies,duplicate,question,invalid,wontfix,wont-fix,modulesync,skip-changelog
      --future-release #{future_release}
      --header '#{header}'
    ]

    # Append to existing changelog to preserve additional content
    if File.exist?(changelog_path)
      cmd << '--base CHANGELOG.md'
    else
      cmd << '--since-tag' << '202501080'
    end

    sh cmd.join(' ')
  end
end
# rubocop:enable Rake/DuplicateTask

desc 'Show component change information between two tags from component_info.json'
task 'release:changelog_components:diff', %i[old_tag new_tag include_project_component_additions] do |_, args|
  abort 'You must provide old_tag and new_tag, e.g. rake "release:changelog_components:diff[2026.06.11.1,2026.06.12.1,true]"' if args[:old_tag].to_s.empty? || args[:new_tag].to_s.empty?

  data_file = File.expand_path('../component_info.json', __dir__)
  data = JSON.parse(File.read(data_file))

  abort "No component information found for old_tag #{args[:old_tag]} in #{data_file}" unless data.key?(args[:old_tag])
  abort "No component information found for new_tag #{args[:new_tag]} in #{data_file}" unless data.key?(args[:new_tag])

  include_project_component_additions = !%w[0 false no off].include?(args[:include_project_component_additions].to_s.downcase)

  component_lines = build_component_change_lines(
    data[args[:old_tag]],
    data[args[:new_tag]],
    include_project_component_additions: include_project_component_additions
  )

  if component_lines.empty?
    puts "No component changes detected between #{args[:old_tag]} and #{args[:new_tag]}"
  else
    puts component_lines.join
  end
end

desc 'Inject component change information into changelog'
task 'release:changelog_components', ['tag'] do |_, args|
  changelog = File.expand_path('../CHANGELOG.md', __dir__)
  data_file = File.expand_path('../component_info.json', __dir__)
  data = JSON.parse(File.read(data_file))

  tag = args[:tag].to_s.empty? ? data.keys.first : args[:tag]
  abort "No component information found for tag #{tag} in #{data_file}" unless data.key?(tag)
  abort "Data for tag #{tag} does not appear at the top of the file." unless data.keys.first == tag
  abort "No previous tag data found in #{data_file} to diff against #{tag}" if data.keys[1].nil?

  prev_data = data[data.keys[1]]
  new_data = data[tag]
  component_lines = build_component_change_lines(prev_data, new_data)

  if component_lines.empty?
    puts "No component changes detected for tag #{tag}"
  else
    content = File.read(changelog)
    new_content = content.sub('**Merged pull requests:**', "#{component_lines.join}\n**Merged pull requests:**")
    File.write(changelog, new_content)
    puts "Injected component change information into #{changelog} for tag #{tag}"
  end
end

desc 'Prepare the changelog for a new release'
task 'release:prepare' do
  ver = Version.load_from_changelog.next!.to_s
  puts "Preparing release #{ver}"
  # 1. Update component_info.json for this version
  Rake::Task['vox:update_component_info'].invoke(ver)

  # 2. Generate the changelog (github_changelog_generator)
  Rake::Task[:changelog].invoke(ver)

  # 3. Add component info to the changelog
  Rake::Task['release:changelog_components'].invoke(ver)
end
