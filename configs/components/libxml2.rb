#####
# Component release information:
#   https://gitlab.gnome.org/GNOME/libxml2/-/releases
#   https://github.com/GNOME/libxml2/tags
#####
component 'libxml2' do |pkg, settings, platform|
  pkg.version '2.15.1'
  pkg.sha256sum 'c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c'

  libxml2_version_y = pkg.get_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2')
  pkg.url "https://download.gnome.org/sources/libxml2/#{libxml2_version_y}/libxml2-#{pkg.get_version}.tar.xz"
  pkg.mirror "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}.tar.xz"

  if platform.is_aix?
    pkg.environment 'PATH', '/opt/freeware/bin:$(PATH)'
  elsif platform.is_cross_compiled_linux?
    pkg.environment 'PATH', "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
  elsif platform.is_solaris?
    pkg.environment 'PATH',
                    "/opt/pl-build-tools/bin:$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:#{settings[:bindir]}"
    pkg.environment 'CFLAGS', "#{settings[:cflags]} -std=c99"
    pkg.environment 'LDFLAGS', settings[:ldflags]
  elsif platform.is_macos?
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  else
    pkg.environment 'LDFLAGS', settings[:ldflags]
    pkg.environment 'CFLAGS', settings[:cflags]
  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --without-python #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/gtk-doc",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end
end
