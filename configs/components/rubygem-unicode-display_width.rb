#####
# Component release information:
#   https://rubygems.org/gems/unicode-display_width
#   https://github.com/janlelis/unicode-display_width/blob/main/CHANGELOG.md
#####
component 'rubygem-unicode-display_width' do |pkg, settings, platform|
  pkg.version '2.6.0'
  pkg.md5sum '77e719750e6acdd2dbbc9ee10b8b2cbe'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
