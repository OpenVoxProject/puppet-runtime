component 'puppet-ca-bundle-8.x' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/puppet-ca-bundle-8.x.json')

  pkg.build_requires(platform.is_archlinux? ? 'openssl' : "openssl-#{settings[:openssl_version]}")

  openssl_cmd = "#{settings[:bindir]}/openssl"

  target = if platform.is_fips?
             'install-fips'
           else
             'install'
           end

  install_commands = [
    "#{platform[:make]} #{target} OPENSSL=#{openssl_cmd} USER=0 GROUP=0 DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
  ]

  pkg.install do
    install_commands
  end
end
