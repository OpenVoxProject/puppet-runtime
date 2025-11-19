#####
# Component release information:
#   https://rubygems.org/gems/singleton
#####
component 'rubygem-singleton' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.3.0'
  pkg.sha256sum '83ea1bca5f4aa34d00305ab842a7862ea5a8a11c73d362cb52379d94e9615778'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
