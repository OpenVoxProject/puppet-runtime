#####
# Component release information:
#   https://rubygems.org/gems/faraday-net_http
#   https://github.com/lostisland/faraday-net_http/releases
#####
component 'rubygem-faraday-net_http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.4.4'
  pkg.sha256sum '0e78af151747ed1b00f33e25973b4bc220d7f16c00c39676817c8b12331eb588'
  pkg.build_requires 'rubygem-net-http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
