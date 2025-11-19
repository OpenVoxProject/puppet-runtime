#####
# Component release information:
#   https://rubygems.org/gems/unicode-display_width
#   https://github.com/janlelis/unicode-display_width/blob/main/CHANGELOG.md
#####
component 'rubygem-unicode-display_width' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.1.5'
  pkg.sha256sum 'bf566817855ee7ee3adcf7bace0d5906cb14401417db59193f8a5fcedf02dd4e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
