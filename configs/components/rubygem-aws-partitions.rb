#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1305.0'
  pkg.sha256sum 'dbcf06fd557d111f8bba82180b8f32317f756516c40f3df72bdf94851ffbfa96'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
