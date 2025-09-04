#####
# Component release information:
#   https://rubygems.org/gems/base64
#   https://github.com/ruby/base64/releases
#####
component 'rubygem-base64' do |pkg, settings, platform|
  pkg.version '0.3.0'
  pkg.sha256sum '27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
