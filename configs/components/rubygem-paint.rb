#####
# Component release information:
#   https://rubygems.org/gems/paint
#   https://github.com/janlelis/paint/blob/main/CHANGELOG.md
#####
component 'rubygem-paint' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.0'
  pkg.md5sum '5f51716cec1f4fe3db8ba1880f9fc875'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
