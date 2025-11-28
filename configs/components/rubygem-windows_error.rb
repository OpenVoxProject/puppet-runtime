#####
# Component release information:
#   https://rubygems.org/gems/windows_error
#   https://github.com/rapid7/windows_error/tags
#####
component 'rubygem-windows_error' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.1.5'
  pkg.sha256sum '59a827b74a9c7adc8f9d40782e8edc136806a239db79a68dd61d50b6e1d945a0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
