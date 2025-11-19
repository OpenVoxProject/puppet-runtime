#####
# Component release information:
#   https://rubygems.org/gems/puppet-resource_api
#   https://github.com/puppetlabs/puppet-resource_api/releases
#   https://github.com/puppetlabs/puppet-resource_api/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.9.0'
  pkg.sha256sum '4b82e77fad1d3810f3a84ad727aa9fd7c4e8b1179bacc034e9071c0a8f2ebe67'
  pkg.build_requires 'rubygem-hocon'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
