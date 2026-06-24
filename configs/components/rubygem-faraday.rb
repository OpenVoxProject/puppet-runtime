#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.14.3'
  pkg.sha256sum '1882247e6766615c8220b4392bf1d27f6ebb63d8e28267587cef1fb0bf37f278'
  pkg.build_requires 'rubygem-faraday-net_http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
