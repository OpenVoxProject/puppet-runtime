#####
# Component release information:
#   https://rubygems.org/gems/logging
#   https://github.com/TwP/logging/blob/master/History.txt
#####
component 'rubygem-logging' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.0'
  pkg.sha256sum 'ba8893a3c211b836f4131bb93b3eb3137a0c3b1fcd0ec3d570e324d8bdc00ccb'
  pkg.build_requires 'rubygem-little-plugger'
  pkg.build_requires 'rubygem-multi_json'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
