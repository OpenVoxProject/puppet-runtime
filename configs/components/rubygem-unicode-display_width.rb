#####
# Component release information:
#   https://rubygems.org/gems/unicode-display_width
#   https://github.com/janlelis/unicode-display_width/blob/main/CHANGELOG.md
#####
component 'rubygem-unicode-display_width' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.3.0'
  pkg.sha256sum '4b7aa66a4b11db50f6f7e98411215cd0dd10eaecb665d36eec5bcacb3fa0b613'
  pkg.build_requires 'rubygem-unicode-emoji'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
