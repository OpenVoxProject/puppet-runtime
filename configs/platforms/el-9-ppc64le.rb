platform 'el-9-ppc64le' do |plat|
  plat.inherit_from_default
  packages = %w[
    perl
    perl-FindBin
    perl-Getopt-Long
    perl-lib
    patch
    swig
    readline-devel
    zlib-devel
    systemtap-sdt-devel
  ]
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
  plat.install_build_dependencies_with 'dnf install -y --allowerasing '
end
