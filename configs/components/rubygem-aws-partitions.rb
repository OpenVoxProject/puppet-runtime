#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1287.0'
  pkg.sha256sum '76f4c73011654553566c5db5bbef0f24738bb016e923910e8b1b3f9cb7d989ca'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
