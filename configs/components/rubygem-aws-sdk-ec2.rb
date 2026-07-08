#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.629.0'
  pkg.sha256sum '59e85668eea257bc574329e82f505206ba7c1ca0bd1c1aff27e176cc0b63cd2b'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
