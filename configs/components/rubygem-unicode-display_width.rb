#####
# Component release information:
#   https://rubygems.org/gems/unicode-display_width
#   https://github.com/janlelis/unicode-display_width/blob/main/CHANGELOG.md
#####
component 'rubygem-unicode-display_width' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.2.0'
  pkg.sha256sum '0cdd96b5681a5949cdbc2c55e7b420facae74c4aaf9a9815eee1087cb1853c42'
  pkg.build_requires 'rubygem-unicode-emoji'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
