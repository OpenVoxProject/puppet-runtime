#####
# Component release information:
#   https://rubygems.org/gems/date
#####
component 'rubygem-date' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.5.0'
  pkg.sha256sum '5e74fd6c04b0e65d97ad4f3bb5cb2d8efb37f386cc848f46310b4593ffc46ee5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
