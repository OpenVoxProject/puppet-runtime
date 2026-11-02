#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.9.2'
  pkg.sha256sum '9117c7e7d6ee07230e75ce41fb9401ae55354dc654fcd0e862ba41d539e9a610'
  pkg.build_requires 'rubygem-public_suffix'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
