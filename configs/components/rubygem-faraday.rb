#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '2.13.4'
  pkg.sha256sum 'c719ff52cfd0dbaeca79dd83ed3aeea3f621032abf8bc959d1c05666157cac26'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
