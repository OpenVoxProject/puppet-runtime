require 'fileutils'

# Returns the imports of toolchain DLLs that the package doesn't contain. They
# load during the build, where the toolchain is on PATH, and nowhere else.
def unshipped_toolchain_dlls(package_dir, toolchain_bindir)
  binaries = Dir.glob("#{package_dir}/**/*.{dll,so,exe}")
  abort "Found no binaries to check under #{package_dir}" if binaries.empty?

  shipped = binaries.map { |binary| File.basename(binary).downcase }
  puts "Checking the DLL imports of #{binaries.size} binaries against #{toolchain_bindir}"
  binaries.flat_map do |binary|
    output, status = Open3.capture2('objdump', '-p', binary)
    abort "Could not read the imports of #{binary} with objdump" unless status.success?

    output.scan(/DLL Name: (\S+)/).flatten.filter_map do |dll|
      next if shipped.include?(dll.downcase) || !File.exist?(File.join(toolchain_bindir, dll))

      "#{binary} imports #{dll}"
    end
  end
end

namespace :vox do
  desc 'Build vanagon project with Docker'
  task :build, [:project, :platform] do |_, args|
    args.with_defaults(project: 'agent-runtime-main')
    project = args[:project]

    ENV['SOURCE_DATE_EPOCH'] ||= `git log -1 --format=%ct`.chomp

    abort 'You must provide a platform.' if args[:platform].nil? || args[:platform].empty?
    platform = args[:platform]
    os, _ver, arch = platform.match(/^(\w+)-([\w.]+)-(\w+)$/).captures
    if os == 'macos'
      shell = `uname -m`.chomp
      ruby = `ruby -v`.chomp
      abort "Detected shell arch: #{shell}. You must run this build from a #{arch} machine or shell. To do this on the current host, run 'arch -#{arch} /bin/bash'" if shell != arch
      abort "Detected ruby: #{ruby}. You must run this build with a #{arch} Ruby version. To do this on the current host, install Ruby from an #{arch} shell via 'arch -#{arch} /bin/bash'." unless ruby =~ /#{arch}/
    end

    engine = platform =~ /^(macos|windows)-/ ? 'local' : 'docker'
    cmd = "bundle exec vanagon build #{project} #{platform} --engine #{engine} --verbose"

    FileUtils.rm_rf('C:/ProgramFiles64Folder/') if platform =~ /^windows-/

    run_command(cmd, silent: false, print_command: true, report_status: true)

    next unless platform =~ /^windows-/

    toolchain_bindir = platform =~ /^windows-msys2-/ ? '/ucrt64/bin' : '/usr/x86_64-w64-mingw32/sys-root/mingw/bin'
    unshipped = unshipped_toolchain_dlls('C:/ProgramFiles64Folder', toolchain_bindir)
    abort "These binaries import DLLs that are not in the package:\n#{unshipped.join("\n")}" unless unshipped.empty?
  end
end
