#####
# Component release information:
#   https://rubygems.org/gems/aws-sigv4
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sigv4/CHANGELOG.md
#####
component 'rubygem-aws-sigv4' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.12.1'
  pkg.sha256sum '6973ff95cb0fd0dc58ba26e90e9510a2219525d07620c8babeb70ef831826c00'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
