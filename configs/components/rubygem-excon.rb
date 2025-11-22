#####
# Component release information:
#   https://rubygems.org/gems/excon
#####
component 'rubygem-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.1'
  pkg.sha256sum 'bdf66805b7095105e45f7f36244f65c021d2d04a8453757a5d731e6a02587dbb'
  pkg.build_requires 'rubygem-logger'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
