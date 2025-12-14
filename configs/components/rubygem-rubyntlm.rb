#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.5'
  pkg.sha256sum '47013402b99ae29ee93f930af51edaec8c6008556f4be25705a422b4430314f5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
