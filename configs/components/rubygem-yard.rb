#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.46'
  pkg.sha256sum '9b1ee37b5da942811dc584d8bb2dfd0efca0a72c44be30bf8282c34955902855'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
