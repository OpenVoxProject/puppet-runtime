#####
# Component release information: https://github.com/curl/curl/releases
#####
component 'curl' do |pkg, settings, platform|
  pkg.version '8.17.0'
  pkg.sha256sum 'e8e74cdeefe5fb78b3ae6e90cd542babf788fa9480029cfcee6fd9ced42b7910'

  pkg.url "https://curl.se/download/curl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/curl-#{pkg.get_version}.tar.gz"

  pkg.build_requires "openssl-#{settings[:openssl_version]}"
  pkg.build_requires 'puppet-ca-bundle'

  ldflags = settings[:ldflags]
  if platform.is_cross_compiled_linux?
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment 'PKG_CONFIG_PATH', '/opt/puppetlabs/puppet/lib/pkgconfig'
    pkg.environment 'PATH', '/opt/pl-build-tools/bin:$(PATH)'
  elsif platform.is_windows?
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.environment 'NM', '/usr/bin/nm' if platform.name =~ /windowsfips-2016/
    pkg.environment 'CYGWIN', settings[:cygwin]
  elsif platform.is_aix?
    pkg.environment 'PKG_CONFIG_PATH', '/opt/puppetlabs/puppet/lib/pkgconfig'
    pkg.environment 'PATH', "/opt/freeware/bin:$(PATH):#{settings[:bindir]}"
    # exclude -Wl,-brtl
    ldflags = "-L#{settings[:libdir]}"
  else
    pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
  end

  configure_options = []
  configure_options << "--with-ssl=#{settings[:prefix]} --without-libpsl"

  # OpenSSL version 3.0 & up no longer ships by default the insecure algorithms
  # that curl's ntlm module depends on (md4 & des).
  configure_options << '--disable-ntlm' if !settings[:use_legacy_openssl_algos] && settings[:openssl_version] =~ /^3\./

  if (platform.is_solaris? && platform.os_version == '11') || platform.is_aix?
    # Makefile generation with automatic dependency tracking fails on these platforms
    configure_options << '--disable-dependency-tracking'
  end

  if platform.is_macos?
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'CXX', settings[:cxx]
  end

  pkg.configure do
    ["CPPFLAGS='#{settings[:cppflags]}' \
      LDFLAGS='#{ldflags}' \
     ./configure --prefix=#{settings[:prefix]} \
        #{configure_options.join(' ')} \
        --enable-threaded-resolver \
        --disable-ldap \
        --disable-ldaps \
        --with-ca-bundle=#{settings[:prefix]}/ssl/cert.pem \
        --with-ca-path=#{settings[:prefix]}/ssl/certs \
        --without-nghttp2 \
        CFLAGS='#{settings[:cflags]}' \
        #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  install_steps = [
    "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
  ]

  unless ['agent', 'pdk'].include?(settings[:runtime_project])
    # Most projects won't need curl binaries, so delete them after installation.
    # Note that the agent _should_ include curl binaries; Some projects and
    # scripts depend on them and they can be helpful in debugging.
    install_steps << "rm -f #{settings[:prefix]}/bin/{curl,curl-config}"
  end

  pkg.install do
    install_steps
  end
end
