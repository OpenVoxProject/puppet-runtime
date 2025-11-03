#####
# Component release information:
#   https://rubygems.org/gems/builder
#   https://github.com/rails/builder/blob/master/CHANGES
#####
component 'rubygem-builder' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.3.0'
  pkg.md5sum '3048be022111b96f47bb17c34c67dbc7'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
