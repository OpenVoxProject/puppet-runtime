#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####
component 'rubygem-aws-sdk-core' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.237.0'
  pkg.sha256sum '9a8b14167a75be07ba7cfd9d27075aa12f1ed897d6eaed808a1c6a20963af32b'
  pkg.build_requires 'rubygem-aws-eventstream'
  pkg.build_requires 'rubygem-aws-partitions'
  pkg.build_requires 'rubygem-aws-sigv4'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-bigdecimal'
  pkg.build_requires 'rubygem-jmespath'
  pkg.build_requires 'rubygem-logger'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
