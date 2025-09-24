require 'fileutils'

namespace :vox do
  desc 'Build vanagon project with Docker'
  task :build, [:project, :platform] do |_, args|
    args.with_defaults(project: 'agent-runtime-main')
    project = args[:project]

    ENV['SOURCE_DATE_EPOCH'] ||= `git log -1 --format=%ct`.chomp

    abort 'You must provide a platform.' if args[:platform].nil? || args[:platform].empty?
    platform = args[:platform]
    os, _ver, arch = platform.match(/^(\w+)-([\w|\.]+)-(\w+)$/).captures

    engine = platform =~ /^(macos|windows)-/ ? 'local' : 'docker'
    cmd = "bundle exec build #{project} #{platform} --engine #{engine}"

    FileUtils.rm_rf('C:/ProgramFiles64Folder/') if platform =~ /^windows-/
    libdir = `ruby -e "require 'rbconfig'; puts RbConfig::CONFIG['rubylibdir']"`.chomp
    begin
      run_command(cmd, silent: false, print_command: true, report_status: true)
    ensure
      # During the build process for macos-all-x86_64, we patch two files in the
      # host ruby installation. If we don't revert those changes, subsequent tasks
      # like uploading to S3 wil fail.
      if platform == 'macos-all-x86_64'
        puts 'Reverting changes to host ruby installation...'
        ['rubygems/ext/builder.rb', 'rubygems/basic_specification.rb'].each do |f|
          FileUtils.rm_f("#{libdir}/#{f}")
          FileUtils.mv("#{libdir}/#{f}.orig", "#{libdir}/#{f}")
        end
      end
    end
  end
end
