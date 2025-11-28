#####
# Component release information:
#   https://rubygems.org/gems/orchestrator_client
#   https://github.com/puppetlabs/orchestrator_client-ruby/tags
#####
component 'rubygem-orchestrator_client' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.7.2'
  pkg.sha256sum 'ed07d84f3cfc6e03258fd91177c679712c5c95f3dbda467498d5ca429ad4b2df'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-faraday-net_http_persistent'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
