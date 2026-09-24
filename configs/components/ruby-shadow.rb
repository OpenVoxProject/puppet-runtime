#####
# Component release information:
#   https://github.com/apalmblad/ruby-shadow/tags
#   https://rubygems.org/gems/ruby-shadow
#####
component 'ruby-shadow' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/ruby-shadow.json')

  pkg.build_requires(platform.is_archlinux? ? 'ruby' : "ruby-#{settings[:ruby_version]}")
  pkg.environment 'PATH', '$(PATH):/usr/ccs/bin:/usr/sfw/bin'

  pkg.environment 'CONFIGURE_ARGS', '--vendor'

  ruby = settings[:host_ruby]

  base = 'resources/patches/ruby_32'
  # https://github.com/apalmblad/ruby-shadow/issues/26
  # if ruby-shadow gets a 3 release this should be removed
  pkg.apply_patch "#{base}/ruby-shadow-taint.patch", strip: '1'
  pkg.apply_patch "#{base}/ruby-shadow-rbconfig.patch", strip: '1'

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
