#####
# Component release information:
#   https://rubygems.org/gems/aws-eventstream
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-eventstream/CHANGELOG.md
#####
component "rubygem-aws-eventstream" do |pkg, settings, platform|
  pkg.version '1.4.0'
  pkg.sha256sum '116bf85c436200d1060811e6f5d2d40c88f65448f2125bc77ffce5121e6e183b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
