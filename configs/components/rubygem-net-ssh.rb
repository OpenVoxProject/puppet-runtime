#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.3.2'
  pkg.sha256sum '65029e213c380e20e5fd92ece663934ab0a0fe888e0cd7cc6a5b664074362dd4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
