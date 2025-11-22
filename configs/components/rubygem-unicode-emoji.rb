#####
# Component release information:
#   https://rubygems.org/gems/unicode-emoji
#####
component 'rubygem-unicode-emoji' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.1.0'
  pkg.sha256sum '4997d2d5df1ed4252f4830a9b6e86f932e2013fbff2182a9ce9ccabda4f325a5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
