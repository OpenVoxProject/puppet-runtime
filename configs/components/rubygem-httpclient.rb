#####
# Component release information:
#   https://rubygems.org/gems/httpclient
#   https://github.com/nahi/httpclient/blob/master/CHANGELOG.md
#####
component 'rubygem-httpclient' do |pkg, settings, platform|
  pkg.version '2.9.0'
  pkg.sha256sum '4b645958e494b2f86c2f8a2f304c959baa273a310e77a2931ddb986d83e498c8'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
