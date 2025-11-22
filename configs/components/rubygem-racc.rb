#####
# Component release information:
#   https://rubygems.org/gems/racc
#####
component 'rubygem-racc' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.8.1'
  pkg.sha256sum '4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
