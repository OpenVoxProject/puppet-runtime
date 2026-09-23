component 'puppet-ca-bundle-main' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/puppet-ca-bundle-main.json')

  pkg.build_requires(platform.is_archlinux? ? 'openssl' : "openssl-#{settings[:openssl_version]}")

  openssl_cmd = "#{settings[:bindir]}/openssl"

  install_commands = [
    "#{platform[:make]} install-bundle OPENSSL=#{openssl_cmd} USER=0 GROUP=0 DESTDIR=#{File.join(settings[:prefix], 'ssl')}"
  ]

  pkg.install do
    install_commands
  end
end
