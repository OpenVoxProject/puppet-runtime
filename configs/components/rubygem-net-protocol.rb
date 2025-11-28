#####
# Component release information:
#   https://rubygems.org/gems/net-protocol
#####
component 'rubygem-net-protocol' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.2.2'
  pkg.sha256sum 'aa73e0cba6a125369de9837b8d8ef82a61849360eba0521900e2c3713aa162a8'
  pkg.build_requires 'rubygem-timeout'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
