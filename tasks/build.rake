require 'fileutils'

namespace :vox do
  desc 'Build vanagon project with Docker'
  task :build, [:project, :platform] do |_, args|
    # This is not currently really any different than 'bundle exec build agent-runtime-main <platform> --engine docker',
    # but adding this machinery so we can make it fancier later and have a common way to build
    # locally and in an action.
    args.with_defaults(project: 'agent-runtime-main')
    project = args[:project]

    ENV['SOURCE_DATE_EPOCH'] ||= `git log -1 --format=%ct`.chomp

    abort 'You must provide a platform.' if args[:platform].nil? || args[:platform].empty?
    platform = args[:platform]

    engine = platform =~ /^(osx|windows)-/ ? 'local' : 'docker'
    cmd = "bundle exec vanagon build #{project} #{platform} --engine #{engine}"

    if platform =~ /^windows-/
      FileUtils.rm_rf('C:/ProgramFiles64Folder')
    else
      FileUtils.rm_rf('/opt/puppetlabs')
      FileUtils.rm_rf('/etc/puppetlabs')
    end

    run_command(cmd, silent: false, print_command: true, report_status: true)
  end
end
