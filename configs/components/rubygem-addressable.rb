#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.9.1'
  pkg.sha256sum 'f1212365945455c84e8d031eea40fc6bedf0c663a78d95b3ab93591040bc5c35'
  pkg.build_requires 'rubygem-public_suffix'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
