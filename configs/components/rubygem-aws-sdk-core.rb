#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####
component 'rubygem-aws-sdk-core' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.257.0'
  pkg.sha256sum 'a92ad19c7ff668cec6688ee3200ee562da80647a3bbeed9fda02e8b0ca6492c6'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  pkg.build_requires 'rubygem-aws-eventstream'
  pkg.build_requires 'rubygem-aws-partitions'
  pkg.build_requires 'rubygem-aws-sigv4'
  pkg.build_requires 'rubygem-jmespath'
  pkg.build_requires 'rubygem-rexml'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
