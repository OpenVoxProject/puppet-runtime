#####
# Component release information:
#   https://rubygems.org/gems/faraday-excon
#   https://github.com/excon/faraday-excon/tags
#   https://github.com/excon/faraday-excon/releases
#####
component 'rubygem-faraday-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.0'
  pkg.sha256sum 'c5fc7175ab284b164496559e35f550587ec5b028b3cdbb40b7ebe83aa7e5b575'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
