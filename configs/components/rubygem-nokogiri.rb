component 'rubygem-nokogiri' do |pkg, settings, _platform|
  pkg.version '1.14.2'
  pkg.sha256sum 'c765a74aac6cf430a710bb0b6038b8ee11f177393cd6ae8dadc7a44a6e2658b6'

  cflags = platform.is_macos? ? '--with-cflags="-Wno-incompatible-function-pointer-types"' : ''
  settings["#{pkg.get_name}_gem_install_options".to_sym] = "--platform=ruby -- \
        --use-system-libraries \
        --with-xml2-lib=#{settings[:libdir]} \
        --with-xml2-include=#{settings[:includedir]}/libxml2 \
        --with-xslt-lib=#{settings[:libdir]} \
        --with-xslt-include=#{settings[:includedir]} \
	#{cflags}"
  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.build_requires 'rubygem-mini_portile2'
  gem_home = settings[:gem_home]
  pkg.environment "GEM_HOME", gem_home
  if platform.is_macos?
    pkg.environment "PKG_CONFIG_PATH", "#{settings[:libdir]}/pkgconfig"
    if platform.is_cross_compiled?
      pkg.install do
        "rm -r #{gem_home}/gems/nokogiri-#{pkg.get_version}/ext/nokogiri/tmp"
      end
    end
  end
end
