#####
# Component release information:
#   https://rubygems.org/gems/rubyzip
#   https://github.com/rubyzip/rubyzip/releases
#   https://github.com/rubyzip/rubyzip/blob/master/Changelog.md
#####
component 'rubygem-rubyzip' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.0.2'
  pkg.sha256sum '30f75c0b631e23c0891453acbcc019bc1496cd44f4a3ade4ff76bc09a595cfa6'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
