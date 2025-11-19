#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####
component 'rubygem-aws-sdk-core' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.232.0'
  pkg.sha256sum '05291ae0da4fb69e9b6494fcc2d839584e8345714a93cd01f0f1bf11475619f2'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
