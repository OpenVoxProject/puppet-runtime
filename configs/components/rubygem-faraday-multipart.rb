#####
# Component release information:
#   https://rubygems.org/gems/faraday-multipart
#   https://github.com/lostisland/faraday-multipart/releases
#####   
component 'rubygem-faraday-multipart' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.1'
  pkg.sha256sum '77a18ff40149030fd1aef55bb4fc7a67ce46419a8a3fcd010e28c2526e8d8903'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
