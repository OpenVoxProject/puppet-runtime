#####
# Component release information:
#   https://rubygems.org/gems/little-plugger
#   https://github.com/TwP/little-plugger/blob/master/History.txt
#####
component 'rubygem-little-plugger' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.4'
  pkg.md5sum '8b1cf294a87eaabd12d5326bc13d7fe0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
