#####
# Component release information (lol):
#   https://rubygems.org/gems/openvox
#   https://github.com/OpenVoxProject/openvox/releases
# Notes:
#   To be replaced with openvox
#####
component 'rubygem-openvox' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '8.24.0'
  pkg.sha256sum '506408465c5aaa9c366beee89dbcc610f7c970aa9fd5af45f829b9ac57c7b0a8'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-benchmark'
  pkg.build_requires 'rubygem-concurrent-ruby'
  pkg.build_requires 'rubygem-deep_merge'
  pkg.build_requires 'rubygem-fast_gettext'
  pkg.build_requires 'rubygem-getoptlong'
  pkg.build_requires 'rubygem-locale'
  pkg.build_requires 'rubygem-multi_json'
  pkg.build_requires 'rubygem-openfact'
  pkg.build_requires 'rubygem-ostruct'
  pkg.build_requires 'rubygem-puppet-resource_api'
  pkg.build_requires 'rubygem-racc'
  pkg.build_requires 'rubygem-scanf'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
