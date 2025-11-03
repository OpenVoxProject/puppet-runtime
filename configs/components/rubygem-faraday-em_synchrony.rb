#####
# Component release information:
#   https://rubygems.org/gems/faraday-em_synchrony
#   https://github.com/lostisland/faraday-em_synchrony/releases
#####
component 'rubygem-faraday-em_synchrony' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.0.1'
  pkg.sha256sum 'bf3ce45dcf543088d319ab051f80985ea6d294930635b7a0b966563179f81750'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
