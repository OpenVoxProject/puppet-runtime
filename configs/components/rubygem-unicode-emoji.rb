#####
# Component release information:
#   https://rubygems.org/gems/unicode-emoji
#####
component 'rubygem-unicode-emoji' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.3.0'
  pkg.sha256sum '11c02fa73290378c066bb0562cd4c87d8e1b706fbbe0059ca12746a4244de8ce'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
