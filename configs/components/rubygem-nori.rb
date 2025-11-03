#####
# Component release information:
#   https://rubygems.org/gems/nori
#   https://github.com/savonrb/nori/releases
#   https://github.com/savonrb/nori/blob/main/CHANGELOG.md
#####
component 'rubygem-nori' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.7.1'
  pkg.md5sum '83952a081b5e86d5aa62943ca9ccf312'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
