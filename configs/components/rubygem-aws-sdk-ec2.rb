#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.653.0'
  pkg.sha256sum '4a235d3d9a4f38c6465b96b395936315369d844a9f2cda39137eefc6ba464eb6'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
