#####
# Component release information:
#   https://rubygems.org/gems/ffi
#   https://github.com/ffi/ffi/blob/master/CHANGELOG.md
# Notes:
#   Read the comments in the code below carefully.
#####
component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.17.2'
  pkg.sha256sum '297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6'

  rb_major_minor_version = settings[:ruby_version].to_f

  if platform.is_windows? && rb_major_minor_version < 3.2
    pkg.sha256sum 'c67b84b1bd54b680bcc23b516e87c96b4585cad3ca9e0afea953c9a9cb90243d'
    pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"

    instance_eval File.read('configs/components/_base-rubygem.rb')
    @component.install = []
    pkg.install { "#{settings[:gem_install]} ffi-#{pkg.get_version}-x64-mingw32.gem" }
  else
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
    settings["#{pkg.get_name}_gem_install_options".to_sym] =
      if rb_major_minor_version > 2.7
        "-- --enable-system-libffi"
      else
        "-- --disable-system-libffi"
      end
    instance_eval File.read('configs/components/_base-rubygem.rb')
  end

  if platform.is_solaris?
    ver, arch = platform.match(/^\w+-(\d+)-(\w+)$/).captures
    cross = platform.is_cross_compiled?

    pkg.environment "MAKE", platform[:make]
    pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/csw/bin:$(PATH)"

    if rb_major_minor_version >= 3.0
      pkg.environment "PATH", "/opt/csw/bin:/opt/pl-build-tools/bin:$(PATH)"
      pkg.environment "PATH", "#{settings[:ruby_bindir]}:$(PATH)" if !cross && arch == 'sparc'
    end
    
    if ver == '11'
      # due to contrib/make_sunver.pl missing on solaris 11 we cannot compile libffi, so we provide the opencsw library
      pkg.environment "CPATH", "/opt/csw/lib/libffi-3.2.1/include" if cross || arch != 'sparc'
      # With Ruby 3.2 on Solaris-11 we install OpenSCW's libffi, no need to copy over the system libffi
      pkg.install_file "/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so" if arch == 'i386' && rb_major_minor_version < 3.2
      base_ruby = '/opt/pl-build-tools/lib/ruby/2.1.0' if cross
      if arch == 'sparc'
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
      end
    end

    if ver == '10'
      pkg.install_file "/opt/csw/lib/libffi.so.6", "#{settings[:libdir]}/libffi.so.6" if arch == 'i386' && rb_major_minor_version < 3.2
      base_ruby = '/opt/csw/lib/ruby/2.0.0' if cross
      if arch == 'sparc'
        sed_exp = 's|CONFIG\["LDFLAGS"\].*|CONFIG["LDFLAGS"] = "-Wl,-rpath-link,/opt/pl-build-tools/sparc-sun-solaris2.10/sysroot/lib:/opt/pl-build-tools/sparc-sun-solaris2.10/sysroot/usr/lib -L. -Wl,-rpath=/opt/puppetlabs/puppet/lib -fstack-protector"|'
        pkg.configure do
          [
            %(#{platform[:sed]} -i '#{sed_exp}' /opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb)
          ]
        end
      end
    end
  end

  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?
  pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)" if platform.is_cross_compiled_linux?

  pkg.environment 'PKG_CONFIG_PATH', '/opt/puppetlabs/puppet/lib/pkgconfig:$(PKG_CONFIG_PATH)'
end
