#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.580.0'
  pkg.sha256sum '0a6ab262fa57a3fec8d07d7f8f43d68ab104df0a1b6bc8f895c53b4d495f014a'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
