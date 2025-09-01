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
    if os == 'macos'
      shell = `uname -m`.chomp
      ruby = `ruby -v`.chomp
      abort "Detected shell arch: #{shell}. You must run this build from a #{arch} machine or shell. To do this on the current host, run 'arch -#{arch} /bin/bash'" if shell != arch
      abort "Detected ruby: #{ruby}. You must run this build with a #{arch} Ruby version. To do this on the current host, install Ruby from an #{arch} shell via 'arch -#{arch} /bin/bash'." unless ruby =~ /#{arch}/
    end

    engine = platform =~ /^(macos|windows)-/ ? 'local' : 'docker'
    cmd = "bundle exec build #{project} #{platform} --engine #{engine}"

    FileUtils.rm_rf('C:/ProgramFiles64Folder/') if platform =~ /^windows-/

    run_command(cmd, silent: false, print_command: true, report_status: true)
  end
end
