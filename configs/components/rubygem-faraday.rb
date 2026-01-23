#####
# Component release information:
#   https://rubygems.org/gems/faraday
#   https://github.com/lostisland/faraday/releases
#####
component 'rubygem-faraday' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.14.1'
  pkg.sha256sum 'a43cceedc1e39d188f4d2cdd360a8aaa6a11da0c407052e426ba8d3fb42ef61c'
  pkg.build_requires 'rubygem-faraday-net_http'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
