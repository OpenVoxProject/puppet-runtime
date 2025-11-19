#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.3'
  pkg.sha256sum '5b321456dba3130351f7451f8669f1afa83a0d26fd63cdec285b7b88e667102d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
