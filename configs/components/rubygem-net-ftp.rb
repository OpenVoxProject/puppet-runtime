#####
# Component release information:
#   https://rubygems.org/gems/net-ftp
#   https://github.com/ruby/net-ftp/releases
#####
component 'rubygem-net-ftp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.3.9'
  pkg.sha256sum '307817ccf7f428f79d083f7e36dbb46a9d1d375e0d23027824de1866f0b13b65'
  pkg.build_requires 'rubygem-net-protocol'
  pkg.build_requires 'rubygem-time'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
