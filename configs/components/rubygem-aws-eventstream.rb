#####
# Component release information:
#   https://rubygems.org/gems/aws-eventstream
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-eventstream/CHANGELOG.md
#####
component "rubygem-aws-eventstream" do |pkg, settings, platform|
  pkg.version "1.3.0"
  pkg.md5sum "e50f43c1f2d7805bbeaa155c6b52e033"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
