#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1184.0'
  pkg.sha256sum '9b994b2df49d31b756523fd66119d8f3947a908e71174f4554b9dce1c728fa69'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
