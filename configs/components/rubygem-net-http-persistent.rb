#####
# Component release information:
#   https://rubygems.org/gems/net-http-persistent
#   https://github.com/drbrain/net-http-persistent/blob/master/History.txt
#####
component 'rubygem-net-http-persistent' do |pkg, settings, platform|
  pkg.version '4.0.4'
  pkg.md5sum '96df0d7f9801e167827a77dbf44cabf5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
