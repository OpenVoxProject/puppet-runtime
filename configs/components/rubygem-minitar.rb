#####
# Component release information:
#   https://rubygems.org/gems/minitar
#   https://github.com/halostatue/minitar/blob/main/CHANGELOG.md
#####
component 'rubygem-minitar' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.0'
  pkg.sha256sum '38db0cfb6f3801017946cdcd8dc53f2cf3fd41ff752892312bf9a1639c9ea23e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
