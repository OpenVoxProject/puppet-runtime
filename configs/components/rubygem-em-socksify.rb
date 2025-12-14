#####
# Component release information:
#   https://rubygems.org/gems/em-socksify
#####
component 'rubygem-em-socksify' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.3.3'
  pkg.sha256sum '7d8d08a7a8acc1263173433a6b5540edd80a8a36e35a066b650c929a3a3974ed'
  pkg.build_requires 'rubygem-eventmachine'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
