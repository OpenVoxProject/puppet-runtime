#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '8.0.2'
  pkg.sha256sum '8d2010b3ba6f7bf5c470aac5e77647d29b2a4dcf000346bafc3c99c439d1c29b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
