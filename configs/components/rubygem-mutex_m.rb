#####
# Component release information:
#   https://rubygems.org/gems/mutex_m
#####
component 'rubygem-mutex_m' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.3.0'
  pkg.sha256sum 'cfcb04ac16b69c4813777022fdceda24e9f798e48092a2b817eb4c0a782b0751'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
