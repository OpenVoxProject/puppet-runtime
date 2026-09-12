#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1286.0'
  pkg.sha256sum '955672fb6cbeccff69b4566a32147d9b8b899afe59220ca786dc60a798f18950'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
