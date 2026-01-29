platform 'sles-16-x86_64' do |plat|
  plat.inherit_from_default

  packages = %w[
    libbz2-devel
    pkg-config
    readline-devel
    zlib-devel
    systemtap-sdt-devel
    systemtap-dtrace
  ]
  plat.provision_with("zypper -n install -y #{packages.join(' ')}")
end
