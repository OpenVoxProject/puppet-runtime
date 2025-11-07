#####
# Component release information: https://github.com/hercules-team/augeas/releases
#####
component 'augeas' do |pkg, settings, platform|
  pkg.version '1.14.1'
  pkg.sha256sum '368bfdd782e4b9c7163baadd621359c82b162734864b667051ff6bcb57b9edff'
  pkg.url "https://github.com/hercules-team/augeas/releases/download/release-#{pkg.get_version}/augeas-#{pkg.get_version}.tar.gz"

  extra_config_flags = ''
  #####
  # Solaris and AIX differences
  #####
  # Solaris and AIX depend on libedit which breaks augeas compliation starting with 1.13.0
  # Releases from 1.13.0 onward are only available from github
  if platform.is_solaris?
    pkg.version '1.12.0'
    pkg.sha256sum '321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87'
    pkg.url "http://download.augeas.net/augeas-#{pkg.get_version}.tar.gz"
    pkg.apply_patch 'resources/patches/augeas/augeas-1.12.0-allow-ad-groups-in-sudoers.patch'
    pkg.apply_patch 'resources/patches/augeas/augeas-1.12.0-allow-hyphen-postgresql-lens.patch'
  else
    pkg.apply_patch 'resources/patches/augeas/augeas-1.14.1-return_reg_enosys.patch'
  end

  if platform.name =~ /solaris-10-sparc/
    # This patch to gnulib fixes a linking error around symbol versioning in pthread.
    pkg.add_source "file://resources/patches/augeas/augeas-#{version}-gnulib-pthread-in-use.patch"
    pkg.configure do
      # gnulib is a submodule, and its files don't exist until after configure,
      # so we apply the patch manually here instead of using pkg.apply_patch.
      ["/usr/bin/gpatch -p0 < ../augeas-#{version}-gnulib-pthread-in-use.patch"]
    end
  end

  extra_config_flags = ' --disable-dependency-tracking' if platform.name =~ /solaris-11|aix/
  #####

  if platform.is_el? || platform.is_fedora?
    # Augeas 1.11.0+ needs a libselinux pkgconfig file on these platforms
    pkg.build_requires 'ruby-selinux'
  end

  if platform.is_macos?
    pkg.build_requires 'readline'
    pkg.build_requires 'autoconf'
    pkg.build_requires 'automake'
    pkg.build_requires 'libtool'
  end

  pkg.build_requires 'libxml2'

  # Ensure we're building against our own libraries when present
  pkg.environment 'PKG_CONFIG_PATH', "#{settings[:libdir]}/pkgconfig"

  if platform.is_aix?
    pkg.environment 'CC', '/opt/freeware/bin/gcc'
    pkg.environment 'PATH', "/opt/freeware/bin:$(PATH):#{settings[:bindir]}"
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    pkg.build_requires 'readline'

    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CFLAGS', "-I#{settings[:includedir]}"
  end

  if platform.is_rpm? && !platform.is_aix?
    if platform.architecture =~ /aarch64|ppc64|ppc64le/
      pkg.build_requires "runtime-#{settings[:runtime_project]}"
      pkg.environment 'PATH', "$(PATH):#{settings[:bindir]}"
      pkg.environment 'CFLAGS', settings[:cflags]
      pkg.environment 'LDFLAGS', settings[:ldflags]
    end
  elsif platform.is_deb?
    pkg.requires 'libreadline6'

    if platform.is_cross_compiled_linux?
      pkg.environment 'PATH', "$(PATH):#{settings[:bindir]}"
      pkg.environment 'CFLAGS', settings[:cflags]
      pkg.environment 'LDFLAGS', settings[:ldflags]
    end

  elsif platform.is_solaris?
    pkg.environment 'PATH', "$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.build_requires 'libedit'
    pkg.build_requires "runtime-#{settings[:runtime_project]}"
    if platform.os_version == '10'
      pkg.environment 'PKG_CONFIG_PATH', '/opt/csw/lib/pkgconfig'
      pkg.environment 'PKG_CONFIG', '/opt/csw/bin/pkg-config'
    elsif !platform.is_cross_compiled? && platform.architecture == 'sparc'
      pkg.environment 'PKG_CONFIG_PATH', "#{settings[:libdir]}/pkgconfig"
      pkg.environment 'PKG_CONFIG', '/usr/bin/pkg-config'
    end
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  end

  pkg.environment 'CFLAGS', settings[:cflags]
  pkg.environment 'CPPFLAGS', settings[:cppflags]
  pkg.environment 'LDFLAGS', settings[:ldflags]

  # fix libtool linking on big sur
  if platform.is_macos?
    if platform.architecture == 'arm64' || platform.is_cross_compiled?
      pkg.configure { ['/opt/homebrew/bin/autoreconf --force --install'] }
    else
      pkg.configure { ['/usr/local/bin/autoreconf --force --install'] }
    end
  end


  pkg.configure do
    ["./configure #{extra_config_flags} --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
