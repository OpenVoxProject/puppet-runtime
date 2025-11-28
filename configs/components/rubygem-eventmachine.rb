#####
# Component release information:
#   https://rubygems.org/gems/eventmachine
#####
component 'rubygem-eventmachine' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.2.7'
  pkg.sha256sum '994016e42aa041477ba9cff45cbe50de2047f25dd418eba003e84f0d16560972'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
