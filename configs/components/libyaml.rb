#####
# Component release information: https://github.com/yaml/libyaml/releases
#####
component 'libyaml' do |pkg, settings, platform|
  pkg.version '0.2.5'
  pkg.sha256sum 'c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4'
  pkg.url "https://github.com/yaml/libyaml/releases/download/#{pkg.get_version}/yaml-#{pkg.get_version}.tar.gz"

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  if platform.is_aix?
    pkg.environment 'PATH', '/opt/freeware/bin:$(PATH)'
  elsif platform.is_cross_compiled_linux?
    pkg.environment 'PATH', "$(PATH):#{settings[:bindir]}"
  elsif platform.is_solaris?
    pkg.environment 'PATH', "$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    pkg.environment 'CFLAGS', "#{settings[:cflags]} -std=c99"
  elsif platform.is_macos?
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  elsif platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --sbindir=#{settings[:prefix]}/bin --libexecdir=#{settings[:prefix]}/lib/libyaml #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end
end
