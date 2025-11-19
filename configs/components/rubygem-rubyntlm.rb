#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.3'
  pkg.md5sum 'e1f7477acf8a7d3effb2a3fb931aa84c'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
