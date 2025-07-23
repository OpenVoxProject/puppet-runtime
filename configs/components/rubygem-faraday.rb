#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '2.13.3'
  pkg.sha256sum 'e9571e7a4ada595b385da5fc749edf7b11dc6aa9d98ab63286c3f28dc4ac01b7'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
