#####
# Component release information:
#   https://github.com/hercules-team/ruby-augeas/releases
#####
component 'ruby-augeas' do |pkg, settings, platform|
  pkg.version '0.6.0'
  pkg.sha256sum '98158a54c655b4823439b4bd38609f01e0b912a3d1453144082b8a5f43b0c4dc'
  pkg.url "https://github.com/hercules-team/ruby-augeas/releases/download/release-#{pkg.get_version}/ruby-augeas-#{pkg.get_version}.tgz"
  pkg.build_requires "ruby-#{settings[:ruby_version]}"
  pkg.build_requires 'augeas'

  pkg.environment 'PATH', '$(PATH):/usr/local/bin:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin'
  pkg.environment 'CONFIGURE_ARGS', '--vendor'
  pkg.environment 'PKG_CONFIG_PATH', "#{File.join(settings[:libdir], 'pkgconfig')}:/usr/lib/pkgconfig"

  if platform.is_aix?
    pkg.environment 'CC', '/opt/freeware/bin/gcc'
    pkg.environment 'PATH', '$(PATH):/opt/freeware/bin'
    pkg.environment 'RUBY', settings[:host_ruby]
    pkg.environment 'LDFLAGS', " -brtl #{settings[:ldflags]}"
  end

  if platform.is_solaris?
    pkg.environment 'RUBY', settings[:host_ruby] if platform.is_cross_compiled?

    ruby = if !platform.is_cross_compiled? && platform.architecture == 'sparc'
             File.join(settings[:ruby_bindir], 'ruby')
           else
             # This should really only be done when cross compiling but
             # to avoid breaking solaris x86_64 in 7.x continue preloading
             # our hook.
             "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
           end
  elsif platform.is_cross_compiled? && (platform.is_linux? || platform.is_macos?)
    pkg.environment 'RUBY', settings[:host_ruby]
    ruby = "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
    pkg.environment 'LDFLAGS', settings[:ldflags]
  elsif platform.is_macos?
    pkg.environment 'PATH', '$(PATH):/opt/homebrew/bin' if platform.architecture == 'arm64'
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
    ruby = File.join(settings[:ruby_bindir], 'ruby')
  else
    ruby = File.join(settings[:ruby_bindir], 'ruby')
  end

  pkg.build do
    build_commands = []

    extconf = "#{ruby} ext/augeas/extconf.rb"
    # WORKAROUND
    # it breaks, because we set LD_LIBRARY_PATH.
    # we need to set PKG_CONFIG_PATH=/opt/puppetlabs/puppet/lib
    #
    # Explanation:
    # redhat derivatives use a pkg-conf-shim. Call path:
    # /usr/bin/pkg-config (uses LD_LIBRARY_PATH=/opt/puppetlabs/lib
    #    LD_LIBRARY_PATH=/opt/puppetlabs/puppet/lib rpm --eval '%{_target_cpu}-%{_vendor}-%{_target_os}%{?_gnu}'
    #    rpm: symbol lookup error: /lib64/librpm_sequoia.so.1: undefined symbol: EVP_idea_cfb64, version OPENSSL_3.0.0
    # that should call /usr/bin/x86_64-linux-gnu-pkg-config
    # that should call /usr/bin/pkgconf
    # we will skip the call stack and call pkgconf direcly.
    extconf += ' --with-pkg-config=/usr/bin/pkgconf' if platform.name =~ /((el|redhatfips)-(9|10))|fedora/
    build_commands << extconf
    build_commands << "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"

    build_commands
  end

  augeas_rb_target = settings[:ruby_vendordir] if settings[:ruby_vendordir]
  # If no alternate vendordir has been set, install into default
  # vendordir for this ruby version.
  augeas_rb_target ||= File.join(settings[:ruby_dir], 'lib', 'ruby', 'vendor_ruby')

  pkg.install_file 'lib/augeas.rb', File.join(augeas_rb_target, 'augeas.rb')
  pkg.install_file 'lib/augeas/facade.rb', File.join(augeas_rb_target, 'augeas', 'facade.rb')

  pkg.install do
    [
      "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1) DESTDIR=/ install"
    ]
  end

  if platform.is_solaris? || platform.is_cross_compiled_linux?
    pkg.install do
      "chown root:root #{augeas_rb_target}"
    end
  end

  # Clean after install in case we are building for multiple rubies.
  pkg.install do
    "#{platform[:make]} -e clean"
  end
end
