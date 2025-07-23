#####
# Component release information:
#   https://rubygems.org/gems/faraday-httpclient
#   https://github.com/lostisland/faraday-httpclient/releases
#####
component 'rubygem-faraday-httpclient' do |pkg, settings, platform|
  pkg.version '2.0.2'
  pkg.sha256sum 'd95fbe60cce5a87e157957d67c539a4c22fb8b0b0611d493a939cdde19d8d67c'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
