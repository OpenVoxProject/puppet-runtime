#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.41'
  pkg.sha256sum '2fad2f362bceb63101f37aeb81d35cfc50b4ae1c11cf22f54b8d46626877a89f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
