# This file is a basis for multiple ruby versions.
# It should not be included as a component; Instead other components should
# load it with instance_eval. See ruby-x.y.z.rb configs.

# Y version, e.g. '2.4.3' -> '2.4'
ruby_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2')

pkg.mirror "#{settings[:buildsources_url]}/ruby-#{pkg.get_version}.tar.gz"
pkg.url "https://cache.ruby-lang.org/pub/ruby/#{ruby_version_y}/ruby-#{pkg.get_version}.tar.gz"

# These may have been overridden in the including file,
# if not then default them back to original values.
ruby_bindir ||= settings[:ruby_bindir]

#############
# ENVIRONMENT
#############

if platform.is_windows?
  pkg.environment 'PATH',
                  "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:tools_root]}/bin):$(shell cygpath -u #{settings[:tools_root]}/include):$(shell cygpath -u #{settings[:bindir]}):$(shell cygpath -u #{ruby_bindir}):$(shell cygpath -u #{settings[:includedir]}):$(PATH)"
  if settings[:cygwin]
    pkg.environment 'CYGWIN', settings[:cygwin]
  elsif settings[:msys]
    pkg.environment 'MSYS', settings[:msys]
  end
  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]
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
  ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
end
