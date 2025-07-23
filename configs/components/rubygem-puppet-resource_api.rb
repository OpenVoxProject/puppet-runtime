#####
# Component release information:
#   https://rubygems.org/gems/puppet-resource_api
#   https://github.com/puppetlabs/puppet-resource_api/releases
#   https://github.com/puppetlabs/puppet-resource_api/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-resource_api' do |pkg, settings, platform|
  pkg.version '1.9.0'
  pkg.md5sum '34a4d89f3241421aae2eb95e0af73cee'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
