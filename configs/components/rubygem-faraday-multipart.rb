#####
# Component release information:
#   https://rubygems.org/gems/faraday-multipart
#   https://github.com/lostisland/faraday-multipart/releases
#####
component 'rubygem-faraday-multipart' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.2.0'
  pkg.sha256sum '7d89a949693714176f612323ca13746a2ded204031a6ba528adee788694ef757'
  pkg.build_requires 'rubygem-multipart-post'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
