#####
# Component release information:
#   https://rubygems.org/gems/faraday-patron
#   https://github.com/lostisland/faraday-patron/releases
#####
component 'rubygem-faraday-patron' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.0.2'
  pkg.sha256sum 'cd4b77d48e3c638ce25c22b6affe2714cf13af99bfa8348c1c7f6733fc5f2086'
  pkg.build_requires 'rubygem-patron'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
