#####
# Component release information:
#   https://rubygems.org/gems/minitar
#   https://github.com/halostatue/minitar/blob/main/CHANGELOG.md
#####
component 'rubygem-minitar' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.2.0'
  pkg.sha256sum '5a74297e61ca0b6d1a3d6eccc139ded4f5eacb5063e92a607f4c81e3d3cd937a'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
