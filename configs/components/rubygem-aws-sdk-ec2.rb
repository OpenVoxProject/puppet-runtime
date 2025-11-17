#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.579.0'
  pkg.sha256sum '45b8a1cc2cb24fbd6ec1565934954e4313a48ee281844242a58f1495ce97d6ca'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
