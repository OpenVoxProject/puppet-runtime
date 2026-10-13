#####
# Component release information:
#   https://rubygems.org/gems/openvox-strings
#   https://github.com/voxpupuli/openvox-strings/releases
#   https://github.com/voxpupuli/openvox-strings/blob/main/CHANGELOG.md
#####
component 'rubygem-openvox-strings' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.2.0'
  pkg.sha256sum '67039708e459f6a4ddad9b2694891aba31967e530f5e9d64d579d4cfecf80136'
  pkg.build_requires 'rubygem-rgen'
  pkg.build_requires 'rubygem-yard'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
