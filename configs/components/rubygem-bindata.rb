#####
# Component release information:
#   https://rubygems.org/gems/bindata
#   https://github.com/dmendel/bindata/blob/master/ChangeLog.rdoc
#####
component 'rubygem-bindata' do |pkg, settings, platform|
  pkg.version '2.5.1'
  pkg.sha256sum '53186a1ec2da943d4cb413583d680644eb810aacbf8902497aac8f191fad9e58'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
