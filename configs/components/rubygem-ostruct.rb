#####
# Component release information:
#   https://rubygems.org/gems/ostruct
#####
component 'rubygem-ostruct' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.3'
  pkg.sha256sum '95a2ed4a4bd1d190784e666b47b2d3f078e4a9efda2fccf18f84ddc6538ed912'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
