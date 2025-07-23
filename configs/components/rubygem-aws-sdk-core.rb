#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####   
component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.209.1"
  pkg.md5sum "7444e5ca941b52a4487c502bf0e80bd9"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
