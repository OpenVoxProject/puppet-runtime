#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####
component 'rubygem-aws-sdk-core' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.268.0'
  pkg.sha256sum '471950504724daa017711705647245ed2dcb44afc658dda88ca38176fe0f4612'
  pkg.build_requires 'rubygem-aws-eventstream'
  pkg.build_requires 'rubygem-aws-partitions'
  pkg.build_requires 'rubygem-aws-sigv4'
  pkg.build_requires 'rubygem-jmespath'
  pkg.build_requires 'rubygem-rexml'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
