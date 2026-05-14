#####
# Component release information:
#   https://github.com/openssl/openssl/releases
#   3.5 isn't latest openssl, but latest LTS: https://openssl-library.org/policies/releasestrat/index.html
#####
component 'openssl' do |pkg, settings, platform|
  pkg.version '3.5.6'
  pkg.sha256sum 'deae7c80cba99c4b4f940ecadb3c3338b13cb77418409238e57d7f31f2a3b736'
  pkg.url "https://github.com/openssl/openssl/releases/download/openssl-#{pkg.get_version}/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  if platform.name =~ /^(amazon-|el-|redhat-|redhatfips-|fedora-)/
    pkg.build_requires 'perl-core'
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
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]

    target = if platform.architecture == 'arm64'
               'darwin64-arm64'
             else
               'darwin64-x86_64'
             end
  elsif platform.is_linux?
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH):/usr/local/bin'

    ldflags = "#{settings[:ldflags]} -Wl,-z,relro"
    case platform.architecture
    when /86$/
      target = 'linux-elf'
      sslflags = '386'
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
    'no-bf',
    'no-cast',
    'no-des',
    'no-rc5',
    'no-mdc2',
    'no-rmd160',
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
