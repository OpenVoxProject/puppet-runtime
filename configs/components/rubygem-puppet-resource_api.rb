#####
# Component release information:
#   https://rubygems.org/gems/puppet-resource_api
#   https://github.com/puppetlabs/puppet-resource_api/releases
#   https://github.com/puppetlabs/puppet-resource_api/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-resource_api' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.1.0'
  pkg.sha256sum '54cab5d93d0811016c9a8842181697db998b30734d5f023e623cdc8d29b22a0d'
  pkg.build_requires 'rubygem-hocon'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
