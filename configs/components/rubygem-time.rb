#####
# Component release information:
#   https://rubygems.org/gems/time
#####
component 'rubygem-time' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.4.1'
  pkg.sha256sum '035f360508a4a4dbabcbbcd3886566b9abd432de89136795d2ff7aec5bcdea61'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
