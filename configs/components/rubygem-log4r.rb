#####
# Component release information:
#   https://rubygems.org/gems/log4r
# Note:
#   Hasn't been updated since 2012. Should probably dump this.
#####
component 'rubygem-log4r' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.10'
  pkg.sha256sum '9b452928c964b7c54c09aeb25ff045b5a722b387b16c9ce37cb1baec00062966'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
