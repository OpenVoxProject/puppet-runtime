#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.15.0'
  pkg.sha256sum '3be0eff0187ed913a1b4f679e9fcfe845b542cdd4f75b76cd6181a4ae1335fff'
  pkg.build_requires 'rubygem-faraday-net_http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
