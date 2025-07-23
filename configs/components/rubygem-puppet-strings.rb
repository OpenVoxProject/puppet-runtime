#####
# Component release information:
#   https://rubygems.org/gems/puppet-strings
#   https://github.com/puppetlabs/puppet-strings/releases
#   https://github.com/puppetlabs/puppet-strings/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet-strings' do |pkg, settings, platform|
  pkg.version '5.0.0'
  pkg.sha256sum '9f93221dab4d9c7441d0c7e4d9b5066e65dc325209487e6638b5cb3b7056fa8b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

