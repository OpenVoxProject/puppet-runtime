#####
# Component release information:
#   https://rubygems.org/gems/rgen
#   https://github.com/mthiede/rgen/blob/master/CHANGELOG
#####
component 'rubygem-rgen' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.10.2'
  pkg.sha256sum 'd978f84887a0b4815ff3a0e0c4d43a15cdeeac9fd4da02db8ec3ecd0f222f371'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
