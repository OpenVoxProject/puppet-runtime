#####
# Component release information (lol):
#   https://rubygems.org/gems/openvox
#   https://github.com/OpenVoxProject/openvox/releases
#####
component 'rubygem-openvox' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '9.4.0'
  pkg.sha256sum '28bb6419806748a0f32a4159a63d3ab896ef6c5bccf5428b2a17fee0d1d38750'
  pkg.build_requires 'rubygem-concurrent-ruby'
  pkg.build_requires 'rubygem-deep_merge'
  pkg.build_requires 'rubygem-fast_gettext'
  pkg.build_requires 'rubygem-locale'
  pkg.build_requires 'rubygem-openfact'
  pkg.build_requires 'rubygem-puppet-resource_api'
  pkg.build_requires 'rubygem-scanf'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
