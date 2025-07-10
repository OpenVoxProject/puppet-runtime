require 'fileutils'

namespace :vox do
  desc 'Cleanup after puppet-runtime compile'
  task :cleanup, [:platform] do |_, args|
    abort 'You must provide a platform.' if args[:platform].nil? || args[:platform].empty?
    platform = args[:platform]

    if platform =~ /^windows-/
      cmd = FileUtils.rm_rf('C:/ProgramFiles64Folder')
    else
      cmd = []
      cmd << FileUtils.rm_rf('/opt/puppetlabs')
      cmd << FileUtils.rm_rf('/etc/puppetlabs')
      cmd << FileUtils.rm_rf('/tmp/delete_me')
    end

    run_command(cmd, silent: false, print_command: true, report_status: true)
  end
end
