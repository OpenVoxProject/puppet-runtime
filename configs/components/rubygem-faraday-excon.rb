#####
# Component release information:
#   https://rubygems.org/gems/faraday-excon
#   https://github.com/excon/faraday-excon/tags
#   https://github.com/excon/faraday-excon/releases
#####
component 'rubygem-faraday-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.0'
  pkg.sha256sum '2a07ff3583468468eb62325c6263d0b2dd39282a8de7dc35908d782de531c8f6'
  pkg.build_requires 'rubygem-excon'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
