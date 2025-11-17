# This file is a basis for multiple ruby versions.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y.z.rb configs.

# Y version, e.g. '2.4.3' -> '2.4'
ruby_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2')

pkg.mirror "#{settings[:buildsources_url]}/ruby-#{pkg.get_version}.tar.gz"
pkg.url "https://cache.ruby-lang.org/pub/ruby/#{ruby_version_y}/ruby-#{pkg.get_version}.tar.gz"


# These may have been overridden in the including file,
# if not then default them back to original values.
ruby_dir ||= settings[:ruby_dir]
ruby_bindir ||= settings[:ruby_bindir]


#############
# ENVIRONMENT
#############

if platform.is_aix?
  if platform.name == 'aix-7.1-ppc'
    pkg.environment "CC", "/opt/pl-build-tools/bin/gcc"
  else
    pkg.environment "CC", "/opt/freeware/bin/gcc"
  end
  pkg.environment 'LDFLAGS', "#{settings[:ldflags]} -Wl,-bmaxdata:0x80000000"
elsif platform.is_solaris?
  if !platform.is_cross_compiled? && platform.architecture == 'sparc'
    pkg.environment 'PATH', "#{settings[:bindir]}:/opt/pl-build-tools/bin:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin:$(PATH)"
    pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  else
    pkg.environment 'PATH', "#{settings[:bindir]}:/opt/csw/bin:/usr/ccs/bin:/usr/sfw/bin:$(PATH)"
    pkg.environment 'CC', '/opt/csw/bin/gcc'
    pkg.environment 'LD', '/opt/csw/bin/gld'
    pkg.environment 'AR', '/opt/csw/bin/gar'
  end
  pkg.environment 'CXX', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
  if platform.os_version == '10'
    # ./configure uses /bin/sh as the default shell when running config.sub on Solaris 10;
    # This doesn't work and halts the configure process. Set CONFIG_SHELL to force use of bash:
    pkg.environment 'CONFIG_SHELL', '/bin/bash'
  end
elsif platform.is_cross_compiled_linux?
  pkg.environment 'PATH', "#{settings[:bindir]}:$(PATH)"
  pkg.environment 'CC', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc"
  pkg.environment 'CXX', "/opt/pl-build-tools/bin/#{settings[:platform_triple]}-g++"
  pkg.environment 'LDFLAGS', "-Wl,-rpath=#{settings[:libdir]}"
elsif platform.is_windows?
  pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:tools_root]}/bin):$(shell cygpath -u #{settings[:tools_root]}/include):$(shell cygpath -u #{settings[:bindir]}):$(shell cygpath -u #{ruby_bindir}):$(shell cygpath -u #{settings[:includedir]}):$(PATH)"
  pkg.environment 'CYGWIN', settings[:cygwin]
  pkg.environment 'LDFLAGS', settings[:ldflags]
  optflags = settings[:cflags] + ' -O3'
  pkg.environment 'optflags', optflags
  pkg.environment 'CFLAGS', optflags
elsif platform.is_macos?
  pkg.environment 'optflags', settings[:cflags]
  pkg.environment 'CFLAGS', settings[:cflags]
  pkg.environment 'CC', settings[:cc]
  pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
elsif settings[:supports_pie]
  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'optflags', settings[:cflags]
end

####################
# BUILD REQUIREMENTS
####################

pkg.build_requires "openssl-#{settings[:openssl_version]}"

if platform.is_aix?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  if platform.name == 'aix-7.1-ppc'
    pkg.build_requires "libedit"
  else
    pkg.build_requires "readline"
  end
elsif platform.is_solaris?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
  pkg.build_requires "libedit" if platform.name =~ /^solaris-10-sparc/
elsif platform.is_cross_compiled_linux?
  pkg.build_requires "runtime-#{settings[:runtime_project]}"
end

#######
# BUILD
#######

pkg.build do
  "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
end

#########
# INSTALL
#########

pkg.install do
  [ "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install" ]
end
