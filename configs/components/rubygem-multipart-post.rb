#####
# Component release information:
#   https://rubygems.org/gems/multipart-post
#   https://github.com/socketry/multipart-post/releases
#####
component 'rubygem-multipart-post' do |pkg, settings, platform|
  pkg.version '2.4.1'
  pkg.md5sum '190a88b4cae633a46b64c30764e5d624'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
