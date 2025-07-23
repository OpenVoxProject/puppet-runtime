#####
# Component release information:
#   https://rubygems.org/gems/faraday_middleware
#   https://github.com/lostisland/faraday_middleware/releases
#####
component 'rubygem-faraday_middleware' do |pkg, settings, platform|
  pkg.version '1.2.1'
  pkg.md5sum 'c1093335f486314a2a68757cafebdaab'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
