#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.15.1'
  pkg.sha256sum '8708154deda739c5e86cc42b74960e23e8491fce0eba9e11639a6a34b1ac288f'
  pkg.build_requires 'rubygem-faraday-net_http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
