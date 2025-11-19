#####
# Component release information:
#   https://rubygems.org/gems/faraday-retry
#   https://github.com/lostisland/faraday-retry/releases
#####
component 'rubygem-faraday-retry' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.2'
  pkg.sha256sum '2402d2029032ebd238a2046221e67f6ef0da78c5a8ce8cd4f8b9c62e4d6451d1'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
