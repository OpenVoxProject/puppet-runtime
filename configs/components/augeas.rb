#####
# Component release information: https://github.com/hercules-team/augeas/releases
#####
component 'augeas' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/augeas.json')

  pkg.apply_patch 'resources/patches/augeas/augeas-1.14.1-return_reg_enosys.patch'

  if platform.is_el? || platform.is_fedora?
    # Augeas 1.11.0+ needs a libselinux pkgconfig file on these platforms:
    pkg.build_requires 'ruby-selinux'
  end

  if platform.is_macos?
    pkg.build_requires 'readline'
    pkg.build_requires 'autoconf'
    pkg.build_requires 'automake'
    pkg.build_requires 'libtool'
  end

  pkg.mirror "#{settings[:buildsources_url]}/augeas-#{pkg.get_version}.tar.gz"

  pkg.build_requires 'libxml2'

  # Ensure we're building against our own libraries when present
  pkg.environment 'PKG_CONFIG_PATH', "#{settings[:libdir]}/pkgconfig"
  pkg.environment 'LD_LIBRARY_PATH', ""
#  pkg.environment 'LD_RUN_PATH', "/opt/puppetlabs/puppet/lib"
  pkg.environment 'LD_RUN_PATH', ""

  if platform.is_rpm?
    if platform.architecture =~ /aarch64/
      pkg.build_requires "runtime-#{settings[:runtime_project]}"
      pkg.environment 'PATH', "$(PATH):#{settings[:bindir]}"
      pkg.environment 'CFLAGS', settings[:cflags]
      pkg.environment 'LDFLAGS', settings[:ldflags]
    end
  elsif platform.is_deb?
    pkg.requires 'libreadline6'
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin:/usr/local/bin'
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CXX', settings[:cxx]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  end

  if settings[:supports_pie]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
  end

  # fix libtool linking on big sur
  if platform.is_macos?
    if platform.architecture == 'arm64'
      pkg.configure { ['/opt/homebrew/bin/autoreconf --force --install'] }
    else
      pkg.configure { ['/usr/local/bin/autoreconf --force --install'] }
    end
  end

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
