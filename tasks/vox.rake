def current_version
  @current_version ||= File.read(File.expand_path('../CHANGELOG.md', __dir__)).match(/^## \[([^\]]+)\]/) { |match| match[1] }
rescue Errno::ENOENT
  puts 'Cannot find current version from CHANGELOG.md.  Ignored'
  @current_version = ''
end

def next_version
  today_prefix = Time.now.utc.strftime('%Y-%m-%d')

  if current_version.start_with?(today_prefix)
    current_version.next
  else
    "#{today_prefix}-1"
  end
end

desc 'Set the full version of the project'
task 'vox:version:bump:full' do
  puts 'This project use the current date as version number.  No bump needed.'
end

desc 'Get the current version of the project'
task 'vox:version:current' do
  puts current_version
end

desc 'Get the next version of the project'
task 'vox:version:next' do
  puts next_version
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
    config.future_release = next_version
  end
rescue LoadError
  task :changelog do
    abort("Run `bundle install --with release` to install the `github_changelog_generator` gem.")
  end
end

task 'release:prepare': :changelog
