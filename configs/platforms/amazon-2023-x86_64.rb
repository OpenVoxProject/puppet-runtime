platform 'amazon-2023-x86_64' do |plat|
  plat.inherit_from_default

  packages = %w[
    perl-FindBin
    perl-lib
    readline-devel
    systemtap-sdt-devel
    systemtap-sdt-dtrace
    zlib-devel
  ]

  plat.provision_with "dnf install -y --allowerasing #{packages.join(' ')}"
  plat.install_build_dependencies_with 'dnf install -y --allowerasing'
  plat.vmpooler_template 'amazon-2023-x86_64'
end
