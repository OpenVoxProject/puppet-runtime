#####
# Component release information:
#   https://rubygems.org/gems/ffi
#   https://github.com/ffi/ffi/blob/master/CHANGELOG.md
# Notes:
#   Read the comments in the code below carefully.
#####
component 'rubygem-ffi' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.17.2'
  pkg.sha256sum '297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6'
  ### End automated maintenance section ###

  # Prior to ruby 3.2, both ruby and the ffi gem vendored a version of libffi.
  # If libffi happened to be installed in /usr/lib, then the ffi gem preferred
  # that instead of building libffi itself. To ensure consistency, we use
  # --disable-system-libffi so that the ffi gem *always* builds libffi, then
  # builds the ffi_c native extension and links it against libffi.so.
  #
  # In ruby 3.2 and up, libffi is no longer vendored. So we created a separate
  # libffi vanagon component which is built before ruby. The ffi gem still
  # vendors libffi, so we use the --enable-system-libffi option to ensure the ffi
  # gem *always* uses the libffi.so we already built. Note the term "system" is
  # misleading, because we override PKG_CONFIG_PATH below so that our libffi.so
  # is preferred, not the one in /usr/lib.
  settings["#{pkg.get_name}_gem_install_options".to_sym] = "-- --enable-system-libffi"
  instance_eval File.read('configs/components/_base-rubygem.rb')

  # due to contrib/make_sunver.pl missing on solaris 11 we cannot compile libffi, so we provide the opencsw library
  pkg.environment "CPATH", "/opt/csw/lib/libffi-3.2.1/include" if platform.name =~ /solaris-11/ && (platform.is_cross_compiled? || platform.architecture != 'sparc')
  pkg.environment "MAKE", platform[:make] if platform.is_solaris?

  if platform.is_solaris?
    if !platform.is_cross_compiled? && platform.architecture == 'sparc'
      pkg.environment "PATH", "#{settings[:ruby_bindir]}:$(PATH)"
    else
      pkg.environment "PATH", "/opt/csw/bin:$(PATH)"
    end
  elsif platform.is_aix?
    pkg.environment 'PATH', '/opt/freeware/bin:$(PATH)'
  end

  if platform.name =~ /solaris-10-i386/
    pkg.install_file "/opt/csw/lib/libffi.so.6", "#{settings[:libdir]}/libffi.so.6"
  end

  pkg.environment 'PKG_CONFIG_PATH', '/opt/puppetlabs/puppet/lib/pkgconfig:$(PKG_CONFIG_PATH)'

  if platform.is_cross_compiled? && !platform.is_macos?
    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  # Change this someday if we ever end up cross compiling OpenVox on Linux
                  # as we won't be using pl-build-tools there
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    # force compilation without system libffi in order to have a statically linked ffi_c.so
    if platform.name =~ /solaris-11-sparc/
      sed_exp = 's|CONFIG\["LDFLAGS"\].*|CONFIG["LDFLAGS"] = "-Wl,-rpath-link,/opt/pl-build-tools/sparc-sun-solaris2.11/sysroot/lib:/opt/pl-build-tools/sparc-sun-solaris2.11/sysroot/usr/lib -L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector"|'

      pkg.configure do
        [
          # libtool always uses the system/solaris ld even if we
          # configure it to use the GNU ld, causing some flag
          # mismatches, so just temporarily move the system ld
          # somewhere else
          %(mv /usr/bin/ld /usr/bin/ld1),
          %(#{platform[:sed]} -i '#{sed_exp}' /opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb)
        ]
      end

      # move ld back after the gem is installed
      pkg.install { "mv /usr/bin/ld1 /usr/bin/ld" }

    elsif platform.name =~ /solaris-10-sparc/
      sed_exp = 's|CONFIG\["LDFLAGS"\].*|CONFIG["LDFLAGS"] = "-Wl,-rpath-link,/opt/pl-build-tools/sparc-sun-solaris2.10/sysroot/lib:/opt/pl-build-tools/sparc-sun-solaris2.10/sysroot/usr/lib -L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector"|'
      pkg.configure do
        [
          %(#{platform[:sed]} -i '#{sed_exp}' /opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb)
        ]
      end
    end

    # FFI 1.13.1 forced the minimum required ruby version to ~> 2.3
    # In order to be able to install the gem using pl-ruby(2.1.9)
    # we need to remove the required ruby version check
    pkg.configure do
      %(#{platform[:sed]} -i '0,/ensure_required_ruby_version_met/b; /ensure_required_ruby_version_met/d' #{base_ruby}/rubygems/installer.rb)
    end
  end
end
