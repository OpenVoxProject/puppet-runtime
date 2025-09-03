#####
# Component release information:
#   https://rubygems.org/gems/puppet-resource_api
#   https://github.com/puppetlabs/puppet-resource_api/releases
#   https://github.com/puppetlabs/puppet-resource_api/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '2.0.0'
  pkg.sha256sum '4649fcb5d5e5f8cbda0887f706b95be5b52a089bcf98ce8ebf0496c3266fd9c4'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
