#####
# Component release information:
#   https://rubygems.org/gems/nori
#   https://github.com/savonrb/nori/releases
#   https://github.com/savonrb/nori/blob/main/CHANGELOG.md
#####
component 'rubygem-nori' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.9.1'
  pkg.sha256sum '72dd12420ccb3f62c32466c2e4d8ab1cc08ae525c2488f30524be6ee8cb6e606'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
