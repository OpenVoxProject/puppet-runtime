#####
# Component release information:
#   https://rubygems.org/gems/faraday-rack
#   https://github.com/lostisland/faraday-rack/releases
#####
component 'rubygem-faraday-rack' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.1.3'
  pkg.sha256sum '9869993a8f1010ade286bda697dea43a8f29f0ab760877d73ec7de5d1d18faed'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
