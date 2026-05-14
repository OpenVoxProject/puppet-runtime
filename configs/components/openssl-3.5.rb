#####
# Component release information:
#   https://github.com/openssl/openssl/releases
#   3.5 isn't latest openssl, but latest LTS: https://openssl-library.org/policies/releasestrat/index.html
#####
component 'openssl' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/openssl-3.5.json')
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  #############################
  # ENVIRONMENT, FLAGS, TARGETS
  #############################

  if platform.is_rpm? && !platform.is_sles?
    pkg.build_requires 'perl-core'
  else
    pkg.build_requires 'perl'
  end

  target = ''
  pkg.environment 'CFLAGS', settings[:cflags]
  pkg.environment 'LDFLAGS', settings[:ldflags]

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

    pkg.environment 'LDFLAGS', "#{settings[:ldflags]} -Wl,-z,relro"
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

  configure_flags << 'no-legacy' << 'no-md4'

  # Individual projects may provide their own openssl configure flags:
  project_flags = settings[:openssl_extra_configure_flags] || []
  configure_flags << project_flags

  pkg.configure do
    ["./Configure LIST", "./Configure #{configure_flags.join(' ')}"]
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
