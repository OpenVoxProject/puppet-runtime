#####
# Component release information:
#   https://rubygems.org/gems/faraday-net_http_persistent
#   https://github.com/lostisland/faraday-net_http_persistent/releases
#####
component 'rubygem-faraday-net_http_persistent' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.1'
  pkg.sha256sum '23ffba37d6a27807a10f033d01918ec958aa73fa6ff0fccfbcd5ce2d2e68fca3'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-net-http-persistent'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
