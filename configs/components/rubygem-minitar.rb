#####
# Component release information:
#   https://rubygems.org/gems/minitar
#   https://github.com/halostatue/minitar/blob/main/CHANGELOG.md
#####
component 'rubygem-minitar' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.12.1'
  pkg.md5sum '975dee1dadeb26a2a01105802c3172ab'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
