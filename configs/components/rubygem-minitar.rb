#####
# Component release information:
#   https://rubygems.org/gems/minitar
#   https://github.com/halostatue/minitar/blob/main/CHANGELOG.md
#####
component 'rubygem-minitar' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.12.1'
  pkg.sha256sum '3a1dbbae8c4c8e67ab8e3951ba36cb93b844c225b29f83e3b90f48226f3d6038'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
