#####
# Component release information:
#   https://github.com/apalmblad/ruby-shadow/tags
#   https://rubygems.org/gems/ruby-shadow
#   contains https://github.com/apalmblad/ruby-shadow/pull/29
#   We are building https://github.com/voxpupuli/ruby-shadow/compare/patch-extconf
#     * contains https://github.com/apalmblad/ruby-shadow/pull/29
#     * diff https://github.com/apalmblad/ruby-shadow/compare/master...bastelfreak:ruby-shadow:patch-extconf
#####
component 'ruby-shadow-patched' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/ruby-shadow-patched.json')

  pkg.build_requires "ruby-#{settings[:ruby_version]}"

  pkg.environment 'CONFIGURE_ARGS', '--vendor'

  if platform.is_cross_compiled?
    pkg.environment 'RUBY', settings[:host_ruby]
    ruby = "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
  else
    ruby = File.join(settings[:ruby_bindir], 'ruby')
  end

  pkg.build do
    [
      "#{ruby} extconf.rb",
      "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    ["#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1) DESTDIR=/ install"]
  end
end
