#####
# Component release information:
#   https://github.com/SELinuxProject/selinux/releases
#####
component 'ruby-selinux' do |pkg, settings, platform|
    # We download tarballs because system development packages (e.g.
  # libselinux-devel) don't necessarily include Swig interface files (*.i files)
  # We select the minimum version available in the platform repos.
  case platform.name
  when /^(el-7|amazon-2|redhatfips-7)-/
    pkg.version "2.0.94"
    pkg.sha256sum 'b8312852306650e9720de5a20fe7560d935d3c90ffedca1cac25bf3f283d8a36'
    pkg.url 'https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20100525/devel/libselinux-2.0.94.tar.gz'
  when /^(el-8|redhatfips-8)-/
    pkg.version '2.9'
    pkg.sha256sum '1bccc8873e449587d9a2b2cf253de9b89a8291b9fbc7c59393ca9e5f5f4d2693'
    pkg.apply_patch 'resources/patches/ruby-selinux/selinux-29-function.patch'
    pkg.url 'https://github.com/SELinuxProject/selinux/releases/download/20190315/libselinux-2.9.tar.gz'
  when /^debian-11-/
    pkg.version '3.1'
    pkg.sha256sum 'ea5dcbb4d859e3f999c26a13c630da2f16dff9462e3cc8cb7b458ac157d112e7'
    pkg.url 'https://github.com/SELinuxProject/selinux/releases/download/20200710/libselinux-3.1.tar.gz'
    pkg.build_requires 'python3-distutils' if platform.is_deb?
  when /^(el-9|redhatfips-9|ubuntu-22.04)-/
    pkg.version '3.3'
    pkg.sha256sum 'acfdee27633d2496508c28727c3d41d3748076f66d42fccde2e6b9f3463a7057'
    pkg.build_requires 'python3-distutils' if platform.is_deb?
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^(amazon-2023|debian-12)-/
    pkg.version '3.4'
    pkg.sha256sum '77c294a927e6795c2e98f74b5c3adde9c8839690e9255b767c5fca6acff9b779'
    pkg.build_requires 'python3-distutils' if platform.is_deb?
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^(sles-15|ubuntu-24.04)-/
    pkg.version '3.5'
    pkg.sha256sum '9a3a3705ac13a2ccca2de6d652b6356fead10f36fb33115c185c5ccdf29eec19'
    pkg.build_requires 'python3-setuptools'
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^(fedora-41|ubuntu-25.04)-/
    pkg.version '3.7'
    pkg.sha256sum 'ea03f42d13a4f95757997dba8cf0b26321fac5d2f164418b4cc856a92d2b17bd'
    pkg.build_requires 'python3-setuptools'
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^(el-10|redhatfips-10|fedora-42)-/
    pkg.version '3.8'
    pkg.sha256sum '0c3756bca047c9270281d7c4dcdecd000b72e38a183c930661eba9690839b541'
    pkg.build_requires 'python3-setuptools'
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^(debian-13|sles-16)-/
    pkg.version '3.8.1'
    pkg.sha256sum 'ec2d2789f931152d21c1db1eb4bc202ce4eccede34d9be9e360e3b45243cee2c'
    pkg.build_requires 'python3-setuptools'
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  when /^fedora-43-/
    pkg.version '3.9'
    pkg.sha256sum 'e7ee2c01dba64a0c35c9d7c9c0e06209d8186b325b0638a0d83f915cc3c101e8'
    pkg.build_requires 'python3-setuptools'
    pkg.url "https://github.com/SELinuxProject/selinux/releases/download/#{pkg.get_version}/libselinux-#{pkg.get_version}.tar.gz"
  else
    raise "The ruby-selinux component needs to be updated for platform #{platform.name}"
  end

  pkg.add_source('file://resources/patches/ruby-selinux/selinuxswig_ruby_wrap.patch')
  pkg.add_source('file://resources/patches/ruby-selinux/selinuxswig_ruby_undefining_allocator.patch')
  pkg.add_source('file://resources/patches/ruby-selinux/undefining_allocator_el_7.patch')

  pkg.build_requires "ruby-#{settings[:ruby_version]}"
  system_include = '-I/usr/include'
  ruby = "#{settings[:ruby_bindir]}/ruby -rrbconfig"

  # The RHEL 9 libselinux-devel package provides headers, but we don't want to
  # use the package becuase of a compatibility issue with the shared library. 
  # Instead, we use the headers provided in the tarball.
  system_include.prepend('-I./include ') if platform.name =~ /el-(9|10)/ 

  if platform.is_cross_compiled_linux?
    pkg.environment 'RUBY', settings[:host_ruby]
    ruby = "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
  end

  cflags = ''

  pkg.build do
    steps = [
      "export RUBYHDRDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"rubyhdrdir\"]')",
      "export VENDORARCHDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"vendorarchdir\"]')",
      "export ARCHDIR=$${RUBYHDRDIR}/$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"arch\"]')",
      "export INCLUDESTR=\"-I#{settings[:includedir]} -I$${RUBYHDRDIR} -I$${ARCHDIR}\"",
      "cp -pr src/{selinuxswig_ruby.i,selinuxswig.i} .",
      "swig -Wall -ruby #{system_include} -o selinuxswig_ruby_wrap.c -outdir ./ selinuxswig_ruby.i"
    ]

    # swig 4.1 generated interface does not need patching, so skip
    # when running debian >= 12, fedora >= 40, etc
    unless (platform.is_debian? && platform.os_version.to_i >= 12) ||
        (platform.is_fedora? && platform.os_version.to_i >= 40) ||
        (platform.is_ubuntu? && platform.os_version.to_i >= 24) ||
        (platform.is_el? && platform.os_version.to_i >= 10)
      steps << "#{platform.patch} --strip=0 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../selinuxswig_ruby_wrap.patch"
    end
    # EL 7 uses an older version of swig (2.0) so a different patch is needed to
    # fix warning:undefining the allocator of T_DATA class
    if platform.name =~ /el-7|redhatfips-7/
      steps << "#{platform.patch} --strip=0 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../undefining_allocator_el_7.patch"
    else
      # Ubuntu 24, Fedora 40, EL 10, and Debian 13 use a newer swig that already has the fix that's
      # being patched
      unless (platform.is_fedora? && platform.os_version.to_i >= 40) ||
          (platform.is_ubuntu? && platform.os_version.to_i >= 24) ||
          (platform.is_el? && platform.os_version.to_i >= 10) ||
          (platform.is_debian? && platform.os_version.to_i >= 13)
        steps << "#{platform.patch} --strip=0 --fuzz=0 --ignore-whitespace --no-backup-if-mismatch < ../selinuxswig_ruby_undefining_allocator.patch"
      end
    end

    # libselinux 3.3 is the minimum version we want to build on RHEL 9, but the
    # libeselinux-devel-3.3 package confusingly installs a shared library that
    # uses 3.4. The hacky workaround for this is to symlink an existing library.
    # PDK builds two Rubies so check if symlink exists first. Similar issue
    # exists for RHEL 10.
    if platform.name =~ /(el|redhatfips)-(9|10)/
      steps << 'if [ ! -L /usr/lib64/libselinux.so ]; then ln -s /usr/lib64/libselinux.so.1 /usr/lib64/libselinux.so; fi'
    end

    steps.concat([
      "gcc $${INCLUDESTR} #{system_include} #{cflags} -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -fPIC -DSHARED -c -o selinuxswig_ruby_wrap.lo selinuxswig_ruby_wrap.c",
      "gcc $${INCLUDESTR} #{system_include} -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -shared -o _rubyselinux.so selinuxswig_ruby_wrap.lo -lselinux -Wl,-z,relro,-z,now,-soname,_rubyselinux.so",
    ])
  end

  pkg.install do
    [
      "export VENDORARCHDIR=$(shell #{ruby} -e 'puts RbConfig::CONFIG[\"vendorarchdir\"]')",
      "install -d $${VENDORARCHDIR}",
      "install -p -m755 _rubyselinux.so $${VENDORARCHDIR}/selinux.so",
      "#{platform[:make]} -e clean",
    ]
  end
end
