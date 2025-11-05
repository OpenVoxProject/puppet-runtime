#####
# Component release information:
#   https://rubygems.org/gems/ed25519
#   https://github.com/RubyCrypto/ed25519/blob/main/CHANGES.md
#####
component 'rubygem-ed25519' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.4.0'
  pkg.sha256sum '16e97f5198689a154247169f3453ef4cfd3f7a47481fde0ae33206cdfdcac506'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
