platform 'amazon-2-aarch64' do |plat|
  plat.inherit_from_default

  packages = %w[
    perl-FindBin
    perl-lib
    perl-IPC-Cmd
    readline-devel
    systemtap-sdt-devel
    systemtap-sdt-trace
    zlib-devel
  ]

  plat.provision_with "yum install -y #{packages.join(' ')}"
  plat.install_build_dependencies_with 'yum install --assumeyes'
  plat.vmpooler_template 'amazon-7-arm64'
end
