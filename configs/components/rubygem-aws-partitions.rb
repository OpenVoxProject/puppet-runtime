#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version '1.1154.0'
  pkg.sha256sum 'be80a8e07b87ce6c936eb251a8f371a887e07ed21ca7f45e5e1b66949eb77294'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
