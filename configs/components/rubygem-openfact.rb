#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.2.2'
  pkg.sha256sum '33cd2c8559a57fc152c9c7bf165f0efcd3f93cf1ccd091b6eee4551d148444af'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
