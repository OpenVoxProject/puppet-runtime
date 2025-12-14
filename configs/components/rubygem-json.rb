#####
# Component release information:
#   https://rubygems.org/gems/json
#####
component 'rubygem-json' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.18.0'
  pkg.sha256sum 'b10506aee4183f5cf49e0efc48073d7b75843ce3782c68dbeb763351c08fd505'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
