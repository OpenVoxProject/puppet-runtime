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

desc 'Inject component change information into changelog'
task 'release:changelog_components', ['tag'] do |_, args|
  abort 'You must provide the tag that will be used for this release.' if args[:tag].nil? || args[:tag].empty?

  changelog = File.expand_path('../CHANGELOG.md', __dir__)
  data_file = File.expand_path('../component_info.json', __dir__)
  data = JSON.parse(File.read(data_file))

  abort "No component information found for tag #{args[:tag]} in #{data_file}" unless data.key?(args[:tag])
  abort "Data for tag #{args[:tag]} does not appear at the top of the file." unless data.keys.first == args[:tag]

  prev_data = data.values[1]
  new_data = data.values[0]

  header_lines = ["\n**Component Changes:**\n", "| Component | Old Version | New Version |\n", "|-----------|-------------|-------------|\n"]
  component_lines = []
  new_components = []
  data[args[:tag]]['components'].sort.each do |comp, ver|
    prev_ver = prev_data['components'][comp]
    next if prev_ver == ver

    new_components << comp if prev_ver.nil?
    component_lines << "| #{comp} | #{prev_data['components'][comp]} | #{ver} |\n"
  end
  component_lines = header_lines + component_lines unless component_lines.empty?

  unless new_components.empty?
    component_lines << "\n**Project component additions:**\n"
    new_components.each do |component|
      projects = new_data['projects']
                 .select { |_, platforms| platforms.values.any? { |components| components.key?(component) } }
                 .keys
      component_lines << "- #{component}: #{projects.join(', ')}\n"
    end
  end

  if component_lines.empty?
    puts "No component changes detected for tag #{args[:tag]}"
  else
    content = File.read(changelog)
    new_content = content.sub('**Merged pull requests:**', "#{component_lines.join}\n**Merged pull requests:**")
    File.write(changelog, new_content)
    puts "Injected component change information into #{changelog} for tag #{args[:tag]}"
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
