#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.10.0'
  pkg.sha256sum '5e13b9c001adf01dd65ad6e0d2a91d2bc07885c0ff2b83f48cbcd95e08d9de62'
  pkg.build_requires 'rubygem-public_suffix'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
