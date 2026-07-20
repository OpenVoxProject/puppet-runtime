#####
# Component release information:
#   https://rubygems.org/gems/excon
#####
component 'rubygem-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.6.0'
  pkg.sha256sum 'ebe2ab83c055ef8e117c62c91a3535b966a59a64868188219d49ab90cd83b65f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
