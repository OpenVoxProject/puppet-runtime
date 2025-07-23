#####
# Component release information:
#   https://rubygems.org/gems/bindata
#   https://github.com/dmendel/bindata/blob/master/ChangeLog.rdoc
#####
component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.5.0'
  pkg.md5sum 'c893016c3b689893b033e12536faeeab'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
