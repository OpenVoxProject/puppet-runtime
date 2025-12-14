#####
# Component release information:
#   https://rubygems.org/gems/reline
#####
component 'rubygem-reline' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.3'
  pkg.sha256sum '1198b04973565b36ec0f11542ab3f5cfeeec34823f4e54cebde90968092b1835'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
