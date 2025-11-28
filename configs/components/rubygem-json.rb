#####
# Component release information:
#   https://rubygems.org/gems/json
#####
component 'rubygem-json' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.16.0'
  pkg.sha256sum 'ca5630320bb5ca23ebfd0bac84532fab56eb357575653b815b9df42c051e1525'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
