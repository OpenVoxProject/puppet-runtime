#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1236.0'
  pkg.sha256sum '00f58da2f959852c70067e1ea9690072891320bebf480c4415e8bdff2eeb1cdf'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
