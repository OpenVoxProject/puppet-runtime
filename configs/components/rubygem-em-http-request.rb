#####
# Component release information:
#   https://rubygems.org/gems/em-http-request
#####
component 'rubygem-em-http-request' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.7'
  pkg.sha256sum '16fbc72b2a6e20c804c564ac5d12e98668c6fcef8c3b1dd2387dff505f2efdab'
  pkg.build_requires 'rubygem-addressable'
  pkg.build_requires 'rubygem-cookiejar'
  pkg.build_requires 'rubygem-em-socksify'
  pkg.build_requires 'rubygem-eventmachine'
  pkg.build_requires 'rubygem-http_parser.rb'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
