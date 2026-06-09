#####
# Component release information:
#   https://rubygems.org/gems/excon
#####
component 'rubygem-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.5.0'
  pkg.sha256sum 'c503ad1d0123bc8ab2a062ff3789dc891ec368cb9e13765ab88a9c58c8bb6d50'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
