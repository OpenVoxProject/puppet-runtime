#####
# Component release information:
#   https://rubygems.org/gems/faraday-net_http
#   https://github.com/lostisland/faraday-net_http/releases
#####
component 'rubygem-faraday-net_http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.4.2'
  pkg.sha256sum 'f147758260d3526939bf57ecf911682f94926a3666502e24c69992765875906c'
  pkg.build_requires 'rubygem-net-http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
