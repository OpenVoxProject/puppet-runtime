#####
# Component release information:
#   https://github.com/openssl/openssl/releases
# Notes:
#   2025-23-07: We are currently staying on the 3.0.x LTS stream. We will
#   need to move to the 3.5.x LTS stream in the next year.
#####
component 'openssl' do |pkg, settings, platform|
  if platform.is_archlinux?
    pkg.build_requires 'openssl'
    pkg.install_only true
  else
    pkg.load_from_json('configs/components/openssl-3.0.json')
    pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

    #############################
    # ENVIRONMENT, FLAGS, TARGETS
    #############################

    if platform.is_rpm? && !platform.is_sles?
      pkg.build_requires 'perl-core'
    else
      pkg.build_requires 'perl'
    end

    target = sslflags = ''
    cflags = settings[:cflags]
    ldflags = settings[:ldflags]

    if platform.is_windows?
      pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
      pkg.environment 'CYGWIN', settings[:cygwin]
      pkg.environment 'MAKE', platform[:make]

      target = 'mingw64'
    elsif platform.is_macos?
      pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
      pkg.environment 'CC', settings[:cc]
      pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]

      target = "darwin64-#{platform.architecture}"

    elsif platform.is_linux?
      pkg.environment 'PATH', '$(PATH):/usr/local/bin'

      ldflags = "#{settings[:ldflags]} -Wl,-z,relro"
      case platform.architecture
      when /aarch64$/
        target = 'linux-aarch64'
      when /64$/
        target = 'linux-x86_64'
      when 'armhf'
        target = 'linux-armv4'
      end
    end

    ####################
    # BUILD REQUIREMENTS
    ####################

    pkg.build_requires "runtime-#{settings[:runtime_project]}"

    ###########
    # CONFIGURE
    ###########

    # Defining --libdir ensures that we avoid the multilib (lib/ vs. lib64/) problem,
    # since configure uses the existence of a lib64 directory to determine
    # if it should install its own libs into a multilib dir. Yay OpenSSL!
    configure_flags = [
      "--prefix=#{settings[:prefix]}",
      '--libdir=lib',
      "--openssldir=#{settings[:prefix]}/ssl",
      'shared',
      'no-gost',
      target,
      sslflags,
      'no-camellia',
      'no-md2',
      'no-ssl3',
      'no-ssl3-method',
      'no-dtls1-method',
      'no-dtls1_2-method',
      'no-aria',
      # 'no-bf', pgcrypto is requires this cipher in postgres for OpenVoxDB
      # 'no-cast', pgcrypto is requires this cipher in postgres for OpenVoxDB
      # 'no-des', pgcrypto is requires this cipher in postgres for OpenVoxDB,
      # should pgcrypto cease needing it, it will also be needed by ntlm
      # and should only be enabled if "use_legacy_openssl_algos" is true.
      'no-rc5',
      'no-mdc2',
      # 'no-rmd160', this is causing failures with pxp, remove once pxp-agent does not need it
      'no-whirlpool'
    ]

    if settings[:use_legacy_openssl_algos]
      pkg.apply_patch 'resources/patches/openssl/openssl-3-activate-legacy-algos.patch'
    else
      configure_flags << 'no-legacy' << 'no-md4'
    end

    # Individual projects may provide their own openssl configure flags:
    project_flags = settings[:openssl_extra_configure_flags] || []
    configure_flags << project_flags

    pkg.environment 'CFLAGS', cflags
    pkg.environment 'LDFLAGS', ldflags
    pkg.configure do
      ["./Configure #{configure_flags.join(' ')}"]
    end

    #######
    # BUILD
    #######

    build_commands = []

    build_commands << "#{platform[:make]} depend"
    build_commands << platform[:make]

    pkg.build do
      build_commands
    end

    #########
    # INSTALL
    #########

    install_prefix = platform.is_windows? ? '' : 'INSTALL_PREFIX=/'
    install_commands = []

    # Skip man and html docs
    install_commands << "#{platform[:make]} #{install_prefix} install_sw install_ssldirs"
    install_commands << "rm -f #{settings[:prefix]}/bin/c_rehash"

    pkg.install do
      install_commands
    end

    pkg.install_file 'LICENSE.txt', "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
  end
end
