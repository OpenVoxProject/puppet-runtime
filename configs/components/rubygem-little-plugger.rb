#####
# Component release information:
#   https://rubygems.org/gems/little-plugger
#   https://github.com/TwP/little-plugger/blob/master/History.txt
#####
component 'rubygem-little-plugger' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.4'
  pkg.sha256sum 'd5f347c00d9d648040ef7c17d6eb09d3d0719adf19ca30d1a3b6fb26d0a631bb'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
