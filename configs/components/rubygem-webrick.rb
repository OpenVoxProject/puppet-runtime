#####
# Component release information:
#   https://rubygems.org/gems/webrick
#   https://github.com/ruby/webrick/releases
#####
component 'rubygem-webrick' do |pkg, settings, platform|
  pkg.version '1.8.2'
  pkg.md5sum 'adbdcb13788330c40b54c1134bf5d7a7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
