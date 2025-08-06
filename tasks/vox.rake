class Version
  attr_reader :date, :x, :raw

  def initialize(v)
    @raw = v

    if (m = v.match(%r{\A(?<date>\d{4}-\d{2}-\d{2})-(?<x>\d+)\z}))
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
    new(version)
  rescue Errno::ENOENT
    new('')
  end

  def to_s
    if malformed?
      raw
    else
      "#{date}-#{x}"
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
    Time.now.strftime('%Y-%m-%d')
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

begin
  require "github_changelog_generator/task"
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = <<~HEADER.chomp
    # Changelog
    All notable changes to this project will be documented in this file.
    HEADER
    config.user = "openvoxproject"
    config.project = "puppet-runtime"
    config.exclude_labels = %w[dependencies duplicate question invalid wontfix wont-fix modulesync skip-changelog]
    config.since_tag = "202501080"
    config.future_release = Version.load_from_changelog.next!.to_s
  end
rescue LoadError
  task :changelog do
    abort("Run `bundle install --with release` to install the `github_changelog_generator` gem.")
  end
end

task 'release:prepare': :changelog
