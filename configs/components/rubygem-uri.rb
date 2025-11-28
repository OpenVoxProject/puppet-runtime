#####
# Component release information:
#   https://rubygems.org/gems/uri
#####
component 'rubygem-uri' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.1'
  pkg.sha256sum '379fa58d27ffb1387eaada68c749d1426738bd0f654d812fcc07e7568f5c57c6'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
