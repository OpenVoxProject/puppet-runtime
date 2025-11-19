#####
# Component release information:
#   https://rubygems.org/gems/nkf
#####
component 'rubygem-nkf' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.2.0'
  pkg.sha256sum 'fbc151bda025451f627fafdfcb3f4f13d0b22ae11f58c6d3a2939c76c5f5f126'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
