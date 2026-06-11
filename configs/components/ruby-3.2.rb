#####
# Component release information:
#   https://github.com/ruby/ruby/releases
#   https://www.ruby-lang.org/en/downloads/releases/
# Notes:
#   The file name of the ruby component must match the ruby_version
#####
component 'ruby-3.2' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/ruby-3.2.json')

  ruby_dir = settings[:ruby_dir]
  ruby_bindir = settings[:ruby_bindir]
  host_ruby = settings[:host_ruby]

  # rbconfig-update is used to munge rbconfigs after the fact.
  pkg.add_source('file://resources/files/ruby/rbconfig-update.rb')

  # Most ruby configuration happens in the base ruby config:
  instance_eval File.read('configs/components/_base-ruby.rb')

  #########
  # PATCHES
  #########

  base = 'resources/patches/ruby_32'

  if platform.is_windows?
    pkg.apply_patch "#{base}/windows_mingw32_mkmf.patch"
    pkg.apply_patch "#{base}/ruby-faster-load_32.patch"
    pkg.apply_patch "#{base}/revert_speed_up_rebuilding_loaded_feature_index.patch"
    pkg.apply_patch "#{base}/revert-ruby-double-load-symlink.patch"
    pkg.apply_patch "#{base}/revert_ruby_utf8_default_encoding.patch"
  end

  if platform.is_fips?
    # This is needed on Ruby < 3.3 until the fix is backported (if ever)
    # See: https://bugs.ruby-lang.org/issues/20000
    pkg.apply_patch "#{base}/openssl3_fips.patch"
  end

  # Upgrade erb 4.0.2 -> 4.0.3.1, fixes CVE-2026-41316
  pkg.apply_patch "#{base}/upgrade-erb-4.0.3.1.patch"

  # Upgrade net-imap 0.3.9 -> 0.6.4.1, fixes CVE-2026-42246, CVE-2026-47240,
  # other CVEs, and build issues.
  pkg.add_source(
    'https://rubygems.org/downloads/net-imap-0.6.4.1.gem',
    {
      sum: '29f0360d75a7efd3539f16ac1957dea5c0a51ddeceb348db4553c3120914ea0d',
      sum_type: 'sha256'
    }
  )
  pkg.configure do
    [
      'cp ../net-imap-0.6.4.1.gem gems/',
      "sed -i.bak 's/^net-imap.*/net-imap 0.6.4.1 https:\\/\\/github.com\\/ruby\\/net-imap/' gems/bundled_gems",
      # This next bit can be done via "make extract-gems", but that requires us
      # to have a "baseruby" installed.
      'tar xf gems/net-imap-0.6.4.1.gem',
      'mkdir .bundle/gems/net-imap-0.6.4.1',
      'tar -C .bundle/gems/net-imap-0.6.4.1 -xzf data.tar.gz'
    ]
  end

  ####################
  # ENVIRONMENT, FLAGS
  ####################

  cflags = settings[:cflags]
  cppflags = settings[:cppflags]
  if platform.is_macos?
    pkg.environment 'optflags', cflags
    pkg.environment 'CFLAGS', cflags
    pkg.environment 'CPPFLAGS', cppflags
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
  elsif platform.is_windows?
    optflags = "#{cflags} -O3"
    pkg.environment 'optflags', optflags
    pkg.environment 'CFLAGS', optflags
    pkg.environment 'MAKE', 'make'
  else
    pkg.environment 'optflags', '-O2'
  end

  special_flags = " --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "

  if (platform.is_debian? && platform.os_version.to_i >= 13) || (platform.is_ubuntu? && platform.os_version.to_f >= 25.04 || platform.is_sles? && platform.os_version.to_i >= 16)
    # A problem with --enable-dtrace, which I suspect may be because of GCC on the Trixie image.
    # Check if this is still needed next time we bump Ruby and/or bump the Debian 13
    # container to the release version.
    cflags += ' -Wno-error=implicit-function-declaration '
  end

  special_flags += " CFLAGS='#{cflags}' LDFLAGS='#{settings[:ldflags]}' CPPFLAGS='#{settings[:cppflags]}' " if settings[:supports_pie]

  # Ruby's build process requires a "base" ruby and we need a ruby to install
  # gems into the /opt/puppetlabs/puppet/lib directory.
  #
  # For native compiles, we don't want ruby's build process to use whatever ruby
  # is in the PATH, as it's probably too old to build ruby 3.2. And we don't
  # want to use/maintain pl-ruby if we don't have to. Instead set baseruby to
  # "no" which will force ruby to build and use miniruby.
  special_flags += ' --with-baseruby=no '

  if platform.is_windows?
    # ruby's configure script guesses the build host is `cygwin`, because we're using
    # cygwin opensshd & bash. So mkmf will convert compiler paths, e.g. -IC:/... to
    # cygwin paths, -I/cygdrive/c/..., which confuses mingw-w64. So specify the build
    # target explicitly.
    special_flags += " CPPFLAGS='-DFD_SETSIZE=2048' debugflags=-g "

    special_flags += if platform.architecture == 'x64'
                       ' --build x86_64-w64-mingw32 '
                     else
                       ' --build i686-w64-mingw32 '
                     end
  elsif platform.is_macos?
    special_flags += " --with-openssl-dir=#{settings[:prefix]} "
  end

  without_dtrace = [
    'macos-all-arm64',
    'macos-all-x86_64',
    'redhatfips-7-x86_64',
    'windows-all-x64',
    'windowsfips-2016-x64'
  ]

  special_flags += ' --enable-dtrace ' unless without_dtrace.include? platform.name

  ###########
  # CONFIGURE
  ###########

  pkg.configure { ['bash autogen.sh'] }

  pkg.configure do
    [
      "bash configure \
        --enable-shared \
        --disable-install-doc \
        --disable-install-rdoc \
        #{settings[:host]} \
        #{special_flags}"
    ]
  end

  #########
  # INSTALL
  #########

  if platform.is_windows?
    # Ruby 3.2 copies bin/gem to $ruby_bindir/gem.cmd, but generates bat files for
    # other gems like bundle.bat, irb.bat, etc. Just rename the cmd.cmd to cmd.bat
    # as we used to in ruby 2.7 and earlier.
    #
    # Note that this step must happen after the install step above.
    pkg.install do
      %w[gem].map do |name|
        "mv #{ruby_bindir}/#{name}.cmd #{ruby_bindir}/#{name}.bat"
      end
    end

    # Required when using `stack-protection-strong` and older versions of mingw-w64-gcc
    pkg.install_file File.join(settings[:gcc_bindir], 'libssp-0.dll'), File.join(settings[:bindir], 'libssp-0.dll')
  end

  target_doubles = {
    'aarch64-redhat-linux' => 'aarch64-linux',
    'powerpc64le-suse-linux' => 'powerpc64le-linux',
    'powerpc64le-linux-gnu' => 'powerpc64le-linux',
    'arm-linux-gnueabihf' => 'arm-linux-eabihf',
    'arm-linux-gnueabi' => 'arm-linux-eabi',
    'x86_64-w64-mingw32' => 'x64-mingw32',
    'i686-w64-mingw32' => 'i386-mingw32'
  }
  rbconfig_topdir = if target_doubles.key?(settings[:platform_triple])
                      File.join(ruby_dir, 'lib', 'ruby', '3.2.0', target_doubles[settings[:platform_triple]])
                    else
                      "$$(#{ruby_bindir}/ruby -e \"puts RbConfig::CONFIG[\\\"topdir\\\"]\")"
                    end

  # When cross compiling or building on non-linux, we sometimes need to patch
  # the rbconfig.rb in the "host" ruby so that later when we try to build gems
  # with native extensions, like ffi, the "host" ruby's mkmf will use the CC,
  # etc specified below. For example, if we're building on mac Intel for ARM,
  # then the CC override allows us to build ffi_c.so for ARM as well. The
  # "host" ruby is configured in _shared-agent-settings
  rbconfig_changes = {}
  if platform.is_macos?
    rbconfig_changes['CC'] = "#{settings[:cc]} #{cflags}"
  elsif platform.is_windows?
    rbconfig_changes['CC'] = if platform.architecture == 'x64'
                               'x86_64-w64-mingw32-gcc'
                             else
                               'i686-w64-mingw32-gcc'
                             end
  end

  pkg.add_source('file://resources/files/ruby_vendor_gems/operating_system.rb')
  defaults_dir = File.join(settings[:libdir], 'ruby/3.2.0/rubygems/defaults')
  pkg.directory(defaults_dir)
  pkg.install_file '../operating_system.rb', File.join(defaults_dir, 'operating_system.rb')

  certs_dir = File.join(settings[:libdir], 'ruby/3.2.0/rubygems/ssl_certs/puppetlabs.net')
  pkg.directory(certs_dir)

  pkg.add_source('file://resources/files/rubygems/COMODO_RSA_Certification_Authority.pem')
  pkg.install_file '../COMODO_RSA_Certification_Authority.pem',
                   File.join(certs_dir, 'COMODO_RSA_Certification_Authority.pem')

  pkg.add_source('file://resources/files/rubygems/GlobalSignRootCA_R3.pem')
  pkg.install_file '../GlobalSignRootCA_R3.pem', File.join(certs_dir, 'GlobalSignRootCA_R3.pem')

  pkg.add_source('file://resources/files/rubygems/DigiCertGlobalRootG2.pem')
  pkg.install_file '../DigiCertGlobalRootG2.pem', File.join(certs_dir, 'DigiCertGlobalRootG2.pem')

  if rbconfig_changes.any?
    pkg.install do
      [
        "#{host_ruby} ../rbconfig-update.rb \"#{rbconfig_changes.to_s.gsub('"', '\"')}\" #{rbconfig_topdir}",
        "cp original_rbconfig.rb #{settings[:datadir]}/doc/rbconfig-#{pkg.get_version}-orig.rb",
        "cp new_rbconfig.rb #{rbconfig_topdir}/rbconfig.rb"
      ]
    end
  end
end
