#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.1.0'
  pkg.sha256sum '569b93bc6941f8efeef55c138577ae2e3ff4f6727657f9f48925c4a657d3f70c'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-logger'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
