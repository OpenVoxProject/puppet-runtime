platform "el-9-x86_64" do |plat|
  plat.inherit_from_default

  packages = %w(
    perl
    perl-FindBin
    perl-Getopt-Long 
    perl-lib
    libsepol
    libsepol-devel
    pkgconfig
    readline-devel
    rpmdevtools
    swig
    systemtap-sdt-devel
    yum-utils
    zlib-devel
  )
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
end

