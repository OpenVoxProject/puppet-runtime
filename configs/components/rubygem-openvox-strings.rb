#####
# Component release information:
#   https://rubygems.org/gems/openvox-strings
#   https://github.com/voxpupuli/openvox-strings/releases
#   https://github.com/voxpupuli/openvox-strings/blob/main/CHANGELOG.md
#####
component 'rubygem-openvox-strings' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.1.0'
  pkg.sha256sum '54787ea8da5759657b3b94dac1af2ec458b4fa1d822c96ddefcde36b91ab39ab'
  pkg.build_requires 'rubygem-rgen'
  pkg.build_requires 'rubygem-yard'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
