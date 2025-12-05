#####
# Component release information:
#   https://rubygems.org/gems/json
#####
component 'rubygem-json' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.17.1'
  pkg.sha256sum 'e0e4824541336a44915436f53e7ea74c687314fb8f88080fa1456f6a34ead92e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
