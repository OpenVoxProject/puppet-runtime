#####
# Component release information:
#   https://rubygems.org/gems/net-http-persistent
#   https://github.com/drbrain/net-http-persistent/blob/master/History.txt
#####
component 'rubygem-net-http-persistent' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.0.6'
  pkg.sha256sum '2abb3a04438edf6cb9e0e7e505969605f709eda3e3c5211beadd621a2c84dd5d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
