#####
# Component release information (lol):
#   https://rubygems.org/gems/puppet
#   https://github.com/puppetlabs/puppet/releases
# Notes:
#   To be replaced with openvox
#####
component 'rubygem-puppet' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '8.10.0'
  pkg.sha256sum 'f2f5de8f5a794ec49ac30f42806c9ffb5cd42c9908ab3014f9d8ea68a21c2a3a'
  pkg.build_requires 'rubygem-concurrent-ruby'
  pkg.build_requires 'rubygem-deep_merge'
  pkg.build_requires 'rubygem-facter'
  pkg.build_requires 'rubygem-fast_gettext'
  pkg.build_requires 'rubygem-getoptlong'
  pkg.build_requires 'rubygem-locale'
  pkg.build_requires 'rubygem-multi_json'
  pkg.build_requires 'rubygem-puppet-resource_api'
  pkg.build_requires 'rubygem-scanf'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###
  
  instance_eval File.read('configs/components/_base-rubygem.rb')
end
