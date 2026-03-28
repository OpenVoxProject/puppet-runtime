#####
# Component release information:
#   https://rubygems.org/gems/addressable
#   https://github.com/sporkmonger/addressable/blob/main/CHANGELOG.md
#####
component 'rubygem-addressable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.8.9'
  pkg.sha256sum 'cc154fcbe689711808a43601dee7b980238ce54368d23e127421753e46895485'
  pkg.build_requires 'rubygem-public_suffix'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
