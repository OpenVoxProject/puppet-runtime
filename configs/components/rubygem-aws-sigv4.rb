#####
# Component release information:
#   https://rubygems.org/gems/aws-sigv4
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sigv4/CHANGELOG.md
#####
component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.10.0"
  pkg.md5sum "f9875621945414c4ee48113a3cb7076e"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
