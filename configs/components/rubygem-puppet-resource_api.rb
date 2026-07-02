#####
# Component release information:
#   https://rubygems.org/gems/puppet-resource_api
#   https://github.com/puppetlabs/puppet-resource_api/releases
#   https://github.com/puppetlabs/puppet-resource_api/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-resource_api' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.0.1'
  pkg.sha256sum '6c3c64450a5de34314867cfbb505a5837729a2639fa88885cde634cb76750a33'
  pkg.build_requires 'rubygem-hocon'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
