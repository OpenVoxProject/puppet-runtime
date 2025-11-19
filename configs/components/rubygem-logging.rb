#####
# Component release information:
#   https://rubygems.org/gems/logging
#   https://github.com/TwP/logging/blob/master/History.txt
#####
component 'rubygem-logging' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.0'
  pkg.md5sum '8953eab63c979ecdac781cbf0da1872a'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
