#####
# Component release information:
#   https://rubygems.org/gems/win32ole
#   https://github.com/ruby/win32ole/releases
#####
component 'rubygem-win32ole' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.9.2'
  pkg.sha256sum '99612fe2c6cb397c0910680f7d1ba6366f08e37aeac83ebaeab9e72ee823e0f5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
