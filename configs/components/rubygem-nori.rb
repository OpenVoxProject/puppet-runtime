#####
# Component release information:
#   https://rubygems.org/gems/nori
#   https://github.com/savonrb/nori/releases
#   https://github.com/savonrb/nori/blob/main/CHANGELOG.md
#####
component 'rubygem-nori' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.7.1'
  pkg.sha256sum '6166cd336959854762073e2fbae888593809cac1b3e904f4fb009313d7226861'
  pkg.build_requires 'rubygem-bigdecimal'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
