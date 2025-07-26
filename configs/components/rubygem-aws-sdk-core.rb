#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-core
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/CHANGELOG.md
#####   
component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version '3.227.0'
  pkg.sha256sum '99071fc5e3ca9347873fd114574319740c3041745df3c74e27875bd912dfc79e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
