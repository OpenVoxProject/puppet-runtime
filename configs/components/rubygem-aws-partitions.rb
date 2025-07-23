#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component "rubygem-aws-partitions" do |pkg, settings, platform|
  pkg.version "1.989.0"
  pkg.md5sum "42f902bac67b87a13561d6599b0b17e3"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
