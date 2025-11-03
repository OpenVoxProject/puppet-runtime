#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.8.7'
  pkg.sha256sum '462986537cf3735ab5f3c0f557f14155d778f4b43ea4f485a9deb9c8f7c58232'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
