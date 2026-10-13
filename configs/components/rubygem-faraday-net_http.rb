#####
# Component release information:
#   https://rubygems.org/gems/faraday-net_http
#   https://github.com/lostisland/faraday-net_http/releases
#####
component 'rubygem-faraday-net_http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.5.0'
  pkg.sha256sum '2e7094c34e38754ee048cc3df47376f8657005d9375f8473bce1c3b526a22e36'
  pkg.build_requires 'rubygem-net-http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
