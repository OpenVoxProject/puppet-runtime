#####
# Component release information:
#   https://github.com/ruby/ruby/releases
#   https://www.ruby-lang.org/en/downloads/releases/
# Notes:
#   The file name of the ruby component must match the ruby_version
#####
component 'ruby-3.2' do |pkg, settings, platform|
  pkg.version '3.2.10'
  pkg.sha256sum '880acb05e08da8c559c56a13e512bae1b472da67c72ebb750c765f9c2134e689'

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

  pkg.apply_patch "#{base}/rbinstall_gem_path.patch" if platform.is_cross_compiled?

  pkg.apply_patch "#{base}/reline_disable_terminfo.patch" if platform.is_aix?

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
  elsif platform.is_cross_compiled?
    pkg.environment 'CROSS_COMPILING', 'true'
  elsif platform.is_aix?
    # When using the default -ggdb3 I was seeing linker errors like, so use -g0 instead:
    #
    # ld: 0711-759 INTERNAL ERROR: Source file dwarf.c, line 528.
    #   Depending on where this product was acquired, contact your service
    #   representative or the approved supplier.
    #   collect2: error: ld returned 16 exit status

    pkg.environment 'optflags', '-O2 -fPIC -g0 '
  elsif platform.is_solaris?
    pkg.environment 'optflags', '-O1'
  else
    pkg.environment 'optflags', '-O2'
  end

  special_flags = " --prefix=#{ruby_dir} --with-opt-dir=#{settings[:prefix]} "

  if (platform.is_debian? && platform.os_version.to_i >= 13) || (platform.is_ubuntu? && platform.os_version =~ /25.04/ || platform.is_sles? && platform.os_version.to_i >= 16)
    # A problem with --enable-dtrace, which I suspect may be because of GCC on the Trixie image.
    # Check if this is still needed next time we bump Ruby and/or bump the Debian 13
    # container to the release version.
    cflags += ' -Wno-error=implicit-function-declaration '
  end

  special_flags += " CFLAGS='#{cflags}' LDFLAGS='#{settings[:ldflags]}' CPPFLAGS='#{settings[:cppflags]}' " if settings[:supports_pie]

  # Ruby's build process requires a "base" ruby and we need a ruby to install
  # gems into the /opt/puppetlabs/puppet/lib directory.
  #
  # For cross-compiles, the base ruby must be executable on the host we're
  # building on (usually Intel), not the arch we're building for (such as
  # SPARC). This is usually pl-ruby.
  #
  # For native compiles, we don't want ruby's build process to use whatever ruby
  # is in the PATH, as it's probably too old to build ruby 3.2. And we don't
  # want to use/maintain pl-ruby if we don't have to. Instead set baseruby to
  # "no" which will force ruby to build and use miniruby.
  special_flags += if platform.is_cross_compiled?
                     " --with-baseruby=#{host_ruby} "
                   else
                     ' --with-baseruby=no '
                   end

  if platform.is_aix?
    # This normalizes the build string to something like AIX 7.1.0.0 rather
    # than AIX 7.1.0.2 or something
    special_flags += " --build=#{settings[:platform_triple]} "
  elsif platform.is_cross_compiled? && platform.is_macos?
    # When the target arch is aarch64, ruby incorrectly selects the 'ucontext' coroutine
    # implementation instead of 'arm64', so specify 'amd64' explicitly
    # https://github.com/ruby/ruby/blob/c9c2245c0a25176072e02db9254f0e0c84c805cd/configure.ac#L2329-L2330
    special_flags += ' --with-coroutine=arm64 '
  elsif platform.is_solaris? && platform.architecture == 'sparc'
    unless platform.is_cross_compiled?
      # configure seems to enable dtrace because the executable is present,
      # explicitly disable it and don't enable it below
      special_flags += ' --enable-dtrace=no '
    end
    special_flags += '--enable-close-fds-by-recvmsg-with-peek '

  elsif platform.is_windows?
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
    'aix-7.2-ppc',
    'el-7-ppc64le',
    'macos-all-arm64',
    'macos-all-x86_64',
    'redhatfips-7-x86_64',
    'sles-12-ppc64le',
    'solaris-11-sparc',
    'solaris-113-sparc',
    'windows-all-x64',
    'windowsfips-2016-x64'
  ]

  special_flags += ' --enable-dtrace ' unless without_dtrace.include? platform.name

  ###########
  # CONFIGURE
  ###########

  # TODO: Remove this once PA-1607 is resolved.
  # TODO: Can we use native autoconf? The dependencies seemed a little too extensive
  if platform.is_aix?
    pkg.configure { ['/opt/freeware/bin/autoconf'] }
  else
    pkg.configure { ['bash autogen.sh'] }
  end

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

  if platform.name =~ /windowsfips-2016/
    # We need the below patch since during ruby build step for windowsfips-2016-x64 agent-runtime builds,
    # the rbconfig.rb file that gets generated contains '\r' trailing character in 'ruby_version' config.
    # We patch rbconfig.rb to remove the '\r' character.
    # This patch has to run after the build step since rbconfig.rb is generated during the build step.
    # This is sort of a hacky way to do this. We need to find why the '\r' character gets appended to
    # 'ruby_version' field in the future so that this patch can be removed - PA-6902.
    pkg.add_source("#{base}/rbconfig_win.patch")
    pkg.build do
      ['TMP=/var/tmp /usr/bin/patch.exe --binary --strip=1 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../rbconfig_win.patch']
    end
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
    'powerpc-ibm-aix7.2.0.0' => 'powerpc-aix7.2.0.0',
    'aarch64-redhat-linux' => 'aarch64-linux',
    'ppc64-redhat-linux' => 'powerpc64-linux',
    'ppc64le-redhat-linux' => 'powerpc64le-linux',
    'powerpc64le-suse-linux' => 'powerpc64le-linux',
    'powerpc64le-linux-gnu' => 'powerpc64le-linux',
    'i386-pc-solaris2.10' => 'i386-solaris2.10',
    'sparc-sun-solaris2.10' => 'sparc-solaris2.10',
    'i386-pc-solaris2.11' => 'i386-solaris2.11',
    'sparc-sun-solaris2.11' => 'sparc-solaris2.11',
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
  if platform.is_aix?
    rbconfig_changes['CC'] = 'gcc'
  elsif platform.is_cross_compiled? || (platform.is_solaris? && platform.architecture != 'sparc')
    # REMIND: why are we overriding rbconfig for solaris intel?
    rbconfig_changes['CC'] = 'gcc'
    rbconfig_changes['warnflags'] =
      '-Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wno-tautological-compare -Wno-parentheses-equality -Wno-constant-logical-operand -Wno-self-assign -Wunused-variable -Wimplicit-int -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration -Wdeprecated-declarations -Wno-packed-bitfield-compat -Wsuggest-attribute=noreturn -Wsuggest-attribute=format -Wno-maybe-uninitialized'
    if platform.name =~ /el-7-ppc64/
      # EL 7 on POWER will fail with -Wl,--compress-debug-sections=zlib so this
      # will remove that entry
      # Matches both endians
      rbconfig_changes['DLDFLAGS'] =
        '-Wl,-rpath=/opt/puppetlabs/puppet/lib -L/opt/puppetlabs/puppet/lib  -Wl,-rpath,/opt/puppetlabs/puppet/lib'
    elsif platform.name =~ /sles-12-ppc64le/
      # the ancient gcc version on sles-12-ppc64le does not understand -fstack-protector-strong, so remove the `strong` part
      rbconfig_changes['LDFLAGS'] =
        '-L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector -rdynamic -Wl,-export-dynamic -L/opt/puppetlabs/puppet/lib'
    end
  elsif platform.is_macos?
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
