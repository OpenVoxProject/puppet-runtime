#####
# Component release information:
#   https://rubygems.org/gems/faraday-net_http
#   https://github.com/lostisland/faraday-net_http/releases
#####
component 'rubygem-faraday-net_http' do |pkg, settings, platform|
  pkg.version '3.4.1'
  pkg.sha256sum '095757fae7872b94eac839c08a1a4b8d84fd91d6886cfbe75caa2143de64ab3b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
