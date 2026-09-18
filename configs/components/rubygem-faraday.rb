#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.14.4'
  pkg.sha256sum '9bb4408c44621b0dbaaaa39e5dbfc4dbe58cc6751b6eb94d16ae9e1f2f2fab6e'
  pkg.build_requires 'rubygem-faraday-net_http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
