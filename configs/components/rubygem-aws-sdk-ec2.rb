#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.656.0'
  pkg.sha256sum '76e07de2bacf38c78ae5d6ab1419fd0d03647afaa0b67e56567259875c703fb7'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
