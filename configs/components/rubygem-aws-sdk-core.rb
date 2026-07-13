#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####
component 'rubygem-aws-sdk-core' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.254.0'
  pkg.sha256sum 'ee3e3220b8468a3c9e59daba18e6ec897bf5c7ce8adcc0670cfa2f1f092112fe'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  pkg.build_requires 'rubygem-aws-eventstream'
  pkg.build_requires 'rubygem-aws-partitions'
  pkg.build_requires 'rubygem-aws-sigv4'
  pkg.build_requires 'rubygem-jmespath'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
