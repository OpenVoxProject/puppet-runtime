#####
# Component release information:
#   https://rubygems.org/gems/net-http-persistent
#   https://github.com/drbrain/net-http-persistent/blob/master/History.txt
#####
component 'rubygem-net-http-persistent' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.0.8'
  pkg.sha256sum 'ef3de8319d691537b329053fae3a33195f8b070bbbfae8bf1a58c796081960e6'
  pkg.build_requires 'rubygem-connection_pool'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
