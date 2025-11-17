#####
# Component release information:
#   https://github.com/openssl/openssl/releases
# Notes:
#   2025-23-07: We are currently staying on the 3.0.x LTS stream. We will
#   need to move to the 3.5.x LTS stream in the next year.
#####
component 'openssl' do |pkg, settings, platform|
  pkg.version '3.0.17'
  pkg.sha256sum 'dfdd77e4ea1b57ff3a6dbde6b0bdc3f31db5ac99e7fdd4eaf9e1fbb6ec2db8ce'
  pkg.url "https://github.com/openssl/openssl/releases/download/openssl-#{pkg.get_version}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  if platform.name =~ /^(el-|redhat-|redhatfips-|fedora-)/
    pkg.build_requires 'perl-core'
  elsif platform.is_solaris?
    # perl is installed in platform definition
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
  elsif platform.is_aix?
    # REMIND: why not PATH?
    pkg.environment 'CC', '/opt/freeware/bin/gcc'

    cflags = "#{settings[:cflags]} -static-libgcc"
    # see https://github.com/openssl/openssl/issues/18007 about -latomic
    # see https://www.ibm.com/docs/en/aix/7.2?topic=l-ld-command about -R<path>, which is equivalent to -rpath
    ldflags = "#{settings[:ldflags]} -Wl,-R#{settings[:libdir]} -latomic -lm"
    target = 'aix-gcc'
  elsif platform.is_solaris?
    pkg.environment 'PATH', '/opt/csw/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin'
    pkg.environment 'CC', "/opt/csw/bin/gcc"
    gcc_lib = "/opt/csw/#{platform.platform_triple}/lib"
    cflags = "#{settings[:cflags]} -fPIC"
    ldflags = "-R#{gcc_lib} -Wl,-rpath=#{settings[:libdir]} -L#{gcc_lib}"
    target = 'solaris-sparcv9-gcc'
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
    pkg.environment "CFLAGS", settings[:cflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
    target = "darwin64-#{platform.architecture}"
  elsif platform.is_linux?
    ldflags = "#{settings[:ldflags]} -Wl,-z,relro"
    if platform.architecture =~ /aarch64$/
      target = 'linux-aarch64'
    elsif platform.architecture =~ /ppc64le|ppc64el/ # Little-endian
      target = 'linux-ppc64le'
    elsif platform.architecture =~ /64$/
      target = 'linux-x86_64'
    elsif platform.architecture == 'armhf'
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
    # 'no-bf', pgcrypto is requires this cipher in postgres for puppetdb
    # 'no-cast', pgcrypto is requires this cipher in postgres for puppetdb
    # 'no-des', pgcrypto is requires this cipher in postgres for puppetdb,
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

  project_flags = [
    'no-dtls',
    'no-dtls1',
    'no-idea',
    'no-seed',
    'no-weak-ssl-ciphers',
    '-DOPENSSL_NO_HEARTBEATS',
  ]

  perl_exec = platform.is_aix? ? '/opt/freeware/bin/perl' : ''
  configure_flags << project_flags

  pkg.environment 'CFLAGS', cflags
  pkg.environment 'LDFLAGS', ldflags
  pkg.configure do
    ["#{perl_exec} ./Configure #{configure_flags.join(' ')}"]
  end

  #######
  # BUILD
  #######

  build_commands = []

  build_commands << "#{platform[:make]} depend"
  build_commands << "#{platform[:make]}"

  pkg.build { build_commands }

  #########
  # INSTALL
  #########

  install_prefix = platform.is_windows? ? '' : 'INSTALL_PREFIX=/'
  install_commands = []

  # "Removes any currently unused modules in kernel and library memory."
  install_commands << "slibclean" if platform.is_aix?

  # Skip man and html docs
  install_commands << "#{platform[:make]} #{install_prefix} install_sw install_ssldirs"
  install_commands << "rm -f #{settings[:prefix]}/bin/c_rehash"

  pkg.install { install_commands }
  pkg.install_file 'LICENSE.txt', "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
end

