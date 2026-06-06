#####
# Component release information:
#   https://github.com/ruby/ruby/releases
#   https://www.ruby-lang.org/en/downloads/releases/
# Notes:
#   The file name of the ruby component must match the ruby_version
#####
component 'ruby-4.0' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/ruby-4.0.json')

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

  # base = 'resources/patches/ruby_40'

  # if platform.is_windows?
  #  pkg.apply_patch "#{base}/windows_mingw32_mkmf.patch"
  #  pkg.apply_patch "#{base}/ruby-faster-load_32.patch"
  #  pkg.apply_patch "#{base}/revert_speed_up_rebuilding_loaded_feature_index.patch"
  #  pkg.apply_patch "#{base}/revert-ruby-double-load-symlink.patch"
  #  pkg.apply_patch "#{base}/revert_ruby_utf8_default_encoding.patch"
  # end

  # if platform.is_fips?
  #  # This is needed on Ruby < 3.3 until the fix is backported (if ever)
  #  # See: https://bugs.ruby-lang.org/issues/20000
  #  pkg.apply_patch "#{base}/openssl3_fips.patch"
  # end

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
  # is in the PATH, as it's probably too old to build ruby 4.0. And we don't
  # want to use/maintain pl-ruby if we don't have to. Instead set baseruby to
  # "no" which will force ruby to build and use miniruby.
  special_flags += ' --with-baseruby=no '
  special_flags += " --with-openssl-dir=#{settings[:prefix]} " if platform.is_macos?

  without_dtrace = [
    'macos-all-arm64',
    'macos-all-x86_64',
    'windows-msys2-x64'
  ]

  # sometimes dtrace will be enabled at compile time if the dtrace binary is present
  special_flags += if without_dtrace.include? platform.name
                     ' --enable-dtrace=no '
                   else
                     ' --enable-dtrace '
                   end

  ###########
  # CONFIGURE
  ###########
  pkg.configure { ['bash autogen.sh'] }

  # we want to provide the different just in time compilers where possible
  # they require a modern rust version
  # https://docs.ruby-lang.org/en/master/jit/zjit_md.html zjit: Rust 1.85.0
  # https://docs.ruby-lang.org/en/master/jit/yjit_md.html yjit: Rust 1.58.0
  platforms_without_rust = [
    'debian-11-aarch64',
    'debian-11-amd64',
    'debian-12-aarch64',
    'debian-12-amd64',
    'debian-13-armhf',
    'macos-all-arm64',
    'macos-all-x86_64',
    'sles-15-x86_64',
    'sles-16-aarch64',
    'sles-16-x86_64',
    'ubuntu-22.04-aarch64',
    'ubuntu-22.04-amd64',
    'ubuntu-24.04-aarch64',
    'ubuntu-24.04-amd64',
    'ubuntu-24.04-armhf',
    'ubuntu-25.04-aarch64',
    'ubuntu-25.04-amd64',
    'ubuntu-25.04-armhf',
    'ubuntu-26.04-armhf',
    'windows-msys2-x64'
  ]
  if platforms_without_rust.include? platform.name
    configure_flags = ''
  else
    pkg.build_requires 'rustc'
    configure_flags = '--enable-yjit --enable-zjit'
  end
  pkg.configure do
    [
      "bash configure \
        --enable-shared \
        --disable-install-doc \
        --disable-install-rdoc \
        #{settings[:host]} \
        #{special_flags} \
        #{configure_flags}"
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
  end

  target_doubles = {
    'aarch64-redhat-linux' => 'aarch64-linux',
    'arm-linux-gnueabihf' => 'arm-linux-eabihf',
    'arm-linux-gnueabi' => 'arm-linux-eabi',
    'x86_64-w64-mingw32' => 'x64-mingw32-ucrt'
  }
  rbconfig_topdir = if target_doubles.key?(settings[:platform_triple])
                      File.join(ruby_dir, 'lib', 'ruby', '4.0.0', target_doubles[settings[:platform_triple]])
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
  rbconfig_changes['CC'] = "#{settings[:cc]} #{cflags}" if platform.is_macos?

  pkg.add_source('file://resources/files/ruby_vendor_gems/operating_system.rb')
  defaults_dir = File.join(settings[:libdir], 'ruby/4.0.0/rubygems/defaults')
  pkg.directory(defaults_dir)
  pkg.install_file '../operating_system.rb', File.join(defaults_dir, 'operating_system.rb')

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
