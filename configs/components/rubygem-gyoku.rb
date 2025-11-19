#####
# Component release information:
#   https://rubygems.org/gems/gyoku
#   https://github.com/savonrb/gyoku/blob/main/CHANGELOG.md
#####
component 'rubygem-gyoku' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.4.0'
  pkg.md5sum 'fecd9488be9b07a250349e9bbe048e5f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
