#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.8.8'
  pkg.sha256sum '7c13b8f9536cf6364c03b9d417c19986019e28f7c00ac8132da4eb0fe393b057'
  pkg.build_requires 'rubygem-public_suffix'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
