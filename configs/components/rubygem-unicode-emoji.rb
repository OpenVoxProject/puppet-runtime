#####
# Component release information:
#   https://rubygems.org/gems/unicode-emoji
#####
component 'rubygem-unicode-emoji' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.2.0'
  pkg.sha256sum '519e69150f75652e40bf736106cfbc8f0f73aa3fb6a65afe62fefa7f80b0f80f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
