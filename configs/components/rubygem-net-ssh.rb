#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '8.0.4'
  pkg.sha256sum '969e1675fe82894178dd04b69236e5dc404e464f57ba006e87679dc448f9bf1b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
