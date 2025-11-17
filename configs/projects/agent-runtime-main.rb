project 'agent-runtime-main' do |proj|
  proj.description 'The OpenVox agent runtime contains third-party components needed for the OpenVox agent'
  proj.license 'See components'
  proj.vendor 'Vox Pupuli <openvox@voxpupuli.org>'
  proj.homepage 'https://github.com/OpenVoxProject'
  proj.version_from_git
  proj.identifier platform.is_macos? ? 'org.voxpupuli' : 'voxpupuli.org'

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  # Generate a tarball, not a package
  proj.generate_archives true
  proj.generate_packages false

  # Windows builds can be really slow
  proj.timeout 7200 if platform.is_windows?

  platform = proj.get_platform

  ########
  # Project Settings
  ########
  proj.setting :ruby_version, '3.2' # Leave the .Z out for Ruby 3.2+
  ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2.0')
  ruby_version_y = proj.ruby_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2')

  proj.setting :openssl_version, '3.0'

  # Use sparingly in component configurations to conditionally include
  # dependencies that should not be in other projects that use puppet-runtime
  proj.setting :runtime_project, 'agent'

  # Windows-specific settings
  proj.setting :company_id, 'VoxPupuli'
  proj.setting :pl_company_id, 'PuppetLabs'
  proj.setting :product_id, 'OpenVox'
  proj.setting :pl_product_id, 'Puppet'
  proj.setting :base_dir, 'ProgramFiles64Folder'
  # We build for windows not in the final destination, but in the paths that correspond
  # to the directory ids expected by WIX. This will allow for a portable installation (ideally).
  windows_install_root = File.join('C:', proj.base_dir, proj.pl_company_id, proj.pl_product_id)

  # Install paths
  proj.setting :install_root, platform.is_windows? ? windows_install_root : '/opt/puppetlabs'
  proj.setting :miscdir, File.join(proj.install_root, 'misc')
  proj.setting :prefix, File.join(proj.install_root, 'puppet')
  proj.setting :bindir, File.join(proj.prefix, 'bin')
  proj.setting :libdir, File.join(proj.prefix, 'lib')
  proj.setting :link_bindir, File.join(proj.install_root, 'bin')
  proj.setting :includedir, File.join(proj.prefix, 'include')
  proj.setting :datadir, File.join(proj.prefix, 'share')
  proj.setting :mandir, File.join(proj.datadir, 'man')
  proj.setting :tmpfilesdir, platform.is_windows? ? 'C:/Windows/Temp' : '/usr/lib/tmpfiles.d'
  proj.setting :sysconfdir, case
    when platform.is_windows? then File.join('C:', 'CommonAppDataFolder', proj.pl_company_id)
    when platform.is_macos? then '/private/etc/puppetlabs'
    else '/etc/puppetlabs'
  end
  
  # Unused by Windows
  proj.setting :logdir, '/var/log/puppetlabs'
  proj.setting :piddir, platform.is_linux? ? '/run/puppetlabs' : '/var/run/puppetlabs'

  # Ruby paths
  proj.setting :ruby_dir, proj.prefix
  proj.setting :ruby_bindir, proj.bindir
  proj.setting :gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version)
  proj.setting :ruby_vendordir, File.join(proj.libdir, 'ruby', 'vendor_ruby')
  proj.setting :ruby_dir_base, File.join(proj.libdir, 'ruby')
  proj.setting :ruby_dir_base_version, File.join(proj.ruby_dir_base, ruby_base_version)
  proj.setting :rubygems_dir, File.join(proj.ruby_dir_base_version, 'rubygems')
  proj.setting :rubygems_ssl_dir, File.join(proj.rubygems_dir, 'ssl_certs')

  # Ruby's build process needs a functional 'baseruby'. When native compiling,
  # ruby will build 'miniruby' and use that as 'baseruby'. When cross compiling,
  # we need a 'host' ruby from somewhere else.
  #
  # Our build process also needs a 'host' ruby to install rubygem-* components.
  proj.setting :host_ruby, case
    when platform.is_windows? then File.join(proj.ruby_bindir, 'ruby.exe')
    when platform.name =~ /solaris-10-sparc/ then '/opt/csw/bin/ruby'
    when platform.is_cross_compiled? && platform.is_macos?
      brewdir = File.dirname(File.dirname(platform.brew))
      File.join(ENV['HOST_RUBY_PREFIX'] || "#{brewdir}/opt/ruby@3.2", 'bin', 'ruby')
    else File.join(proj.ruby_bindir, 'ruby')
  end
  proj.setting :host_gem, case
    when platform.is_windows? then File.join(proj.ruby_bindir, 'gem.bat')
    when platform.name =~ /solaris-10-sparc/ then '/opt/csw/bin/gem2.0'
      when platform.is_cross_compiled? && platform.is_macos?
      brewdir = File.dirname(File.dirname(platform.brew))
      File.join(ENV['HOST_RUBY_PREFIX'] || "#{brewdir}/opt/ruby@3.2", 'bin', 'gem')
    else File.join(proj.ruby_bindir, 'gem')
  end
  proj.setting :gem_install, "#{proj.host_gem} install --no-document --local "
  proj.setting :gem_uninstall, "#{proj.host_gem} uninstall --all --ignore-dependencies "
  # Directory for gems shared by openvox-agent and openvox-server
  proj.setting :puppet_gem_vendor_dir, File.join(proj.libdir, 'ruby', 'vendor_gems')

  # Cross-compiled platforms
  proj.setting :host, case
    when platform.is_cross_compiled_linux? || platform.is_solaris? || platform.is_windows? then "--host #{platform.platform_triple}"
    when platform.is_cross_compiled? && platform.is_macos?
      current_arch = `uname -m`.strip
      current_arch = 'aarch64' if current_arch == 'arm64'
      target_arch = platform.architecture == 'arm64' ? 'aarch64' : platform.architecture
      "--host #{target_arch}-apple-darwin --build #{current_arch}-apple-darwin --target #{target_arch}-apple-darwin"
  end

  # For Windows, we need to specify where tools are located within the Cygwin environment
  if platform.is_windows?
    proj.setting :tools_root, '/usr/x86_64-w64-mingw32/sys-root/mingw' if platform.is_windows?
    proj.setting :gcc_bindir, "#{proj.tools_root}/bin"
    proj.setting :cygwin, 'nodosfilewarning winsymlinks:native'
  end

  # OS X doesn't use RPATH for linking. We shouldn't
  # define it or try to force it in the linker, because this might
  # break gcc or clang if they try to use the RPATH values we forced.
  #
  # We now target MacOS 13 as the minimum version, and build a binary
  # that works for all MacOS versions since then, rather than building
  # separate ones for each version.
  if platform.is_macos?
    proj.setting :deployment_target, '13.0'
    targeting_flags = "-arch #{platform.architecture} -mmacos-version-min=13.0"
    proj.setting :cc, "clang -target #{platform.architecture}-apple-darwin"
    proj.setting :cxx, "clang++ -target #{platform.architecture}-apple-darwin"
  end

  # Compiler flag defaults
  # Harden Linux ELF binaries by compiling with PIE (Position Independent Executables) support,
  # stack canary and full RELRO.

  cppflags = "-I#{proj.includedir} -D_FORTIFY_SOURCE=2"
  cflags = "#{cppflags} -fstack-protector-strong -fPIC -fno-plt -O2"
  ldflags = "-L#{proj.libdir}"
  proj.setting :cppflags, case
    when platform.is_windows? then "-I#{proj.tools_root}/include -I#{proj.tools_root}/include/readline -I#{proj.includedir}"
    when platform.is_macos? then "#{targeting_flags} #{cppflags}"
    else cppflags
  end
  proj.setting :cflags, case
    when platform.is_windows? then "-I#{proj.tools_root}/include -I#{proj.tools_root}/include/readline -I#{proj.includedir}"
    when platform.is_macos? then "#{targeting_flags} #{cflags}"
    else cflags
  end
  proj.setting :ldflags, case
    when platform.is_windows? then "#{ldflags} -L#{proj.tools_root}/lib -Wl,--nxcompat"
    when platform.is_linux? then "#{ldflags} -Wl,-rpath=#{proj.libdir} -Wl,-z,relro -Wl,-z,now"
    when platform.is_aix? then "#{ldflags} -Wl,-brtl"
    else ldflags
  end


  ########
  # Directories
  ########
  proj.directory proj.install_root
  proj.directory proj.prefix
  proj.directory proj.sysconfdir
  proj.directory proj.link_bindir
  proj.directory proj.libdir
  proj.directory proj.ruby_dir_base
  proj.directory proj.ruby_dir_base_version
  proj.directory proj.rubygems_dir
  proj.directory proj.rubygems_ssl_dir
  proj.directory proj.bindir if platform.is_windows? || platform.is_macos?


  ########
  # Components
  ########
  proj.component 'runtime-agent'
  proj.component 'libffi'
  proj.component 'libyaml'
  proj.component "openssl-#{proj.openssl_version}"
  proj.component 'curl'
  proj.component 'puppet-ca-bundle'
  proj.component "ruby-#{proj.ruby_version}"

  proj.component 'rubygem-hocon'
  proj.component 'rubygem-deep_merge'
  proj.component 'rubygem-net-ssh'
  proj.component 'rubygem-semantic_puppet'
  proj.component 'rubygem-text'
  proj.component 'rubygem-locale'
  proj.component 'rubygem-gettext'
  proj.component 'rubygem-fast_gettext'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-scanf'
  proj.component 'rubygem-erubi'
  proj.component 'rubygem-prime'
  proj.component 'rubygem-logger'
  proj.component 'rubygem-base64'
  proj.component 'rubygem-rexml'

  # Platform-specific differences
  if platform.is_macos?
    proj.component 'readline'
    proj.component 'rubygem-CFPropertyList'
  end

  unless platform.is_windows?
    proj.component 'augeas'
    proj.component 'ruby-augeas'
    proj.component 'libxml2'
    proj.component 'libxslt'
    proj.component 'rubygem-sys-filesystem'
  end

  proj.component 'ruby-shadow' unless platform.is_aix? || platform.is_windows?
  proj.component 'ruby-selinux' if platform.is_el? || platform.is_fedora? || platform.is_debian? || platform.is_ubuntu?
  proj.component 'libedit' if platform.is_solaris? # Used instead of readline
  proj.component 'pl-ruby-patch' if platform.is_cross_compiled?
  proj.component 'rubygem-minitar' if platform.is_windows? || platform.is_solaris? || platform.is_aix?

  if platform.is_linux?
    proj.component 'virt-what'
    proj.component 'dmidecode' unless platform.architecture =~ /ppc64/
  end
end
