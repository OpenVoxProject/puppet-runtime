#####
# Component release information:
#   https://rubygems.org/gems/bigdecimal
#####
component 'rubygem-bigdecimal' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.3.1'
  pkg.sha256sum 'eaa01e228be54c4f9f53bf3cc34fe3d5e845c31963e7fcc5bedb05a4e7d52218'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
