#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version '1.1134.0'
  pkg.sha256sum '28f5f6156777ac346904a79ce6cb3b14a521e3866fee12a0da86d7b500266d3e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
