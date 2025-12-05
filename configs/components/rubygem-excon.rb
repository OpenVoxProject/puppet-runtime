#####
# Component release information:
#   https://rubygems.org/gems/excon
#####
component 'rubygem-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.2'
  pkg.sha256sum 'a089babe98638e58042a7d542b2bbd183304527e33d612b6dde22fa491a544a5'
  pkg.build_requires 'rubygem-logger'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
