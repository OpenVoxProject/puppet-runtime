#####
# Component release information:
#   https://rubygems.org/gems/openvox-strings
#   https://github.com/voxpupuli/openvox-strings/releases
#   https://github.com/voxpupuli/openvox-strings/blob/main/CHANGELOG.md
#####
component 'rubygem-openvox-strings' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.0.0'
  pkg.sha256sum '3fd42dfd91d7d42ece6edb4254876937ec5634a65f951d912abcaec30156dc88'
  pkg.build_requires 'rubygem-openvox'
  pkg.build_requires 'rubygem-rgen'
  pkg.build_requires 'rubygem-yard'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

