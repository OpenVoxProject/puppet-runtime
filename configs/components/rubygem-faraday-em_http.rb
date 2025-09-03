#####
# Component release information:
#   https://rubygems.org/gems/faraday-em_http
#   https://github.com/lostisland/faraday-em_http/releases
#####
component 'rubygem-faraday-em_http' do |pkg, settings, platform|
  pkg.version '2.0.1'
  pkg.sha256sum '05d3845d0b298a7dfbfb8205db39d10f1bc898d455be7a678ca6f460aba71632'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
