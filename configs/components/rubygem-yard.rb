#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.45'
  pkg.sha256sum '52e211493f7cb8a3ebf7e104a25a1e73937a3103092545d34cb88fafebb3dc51'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
