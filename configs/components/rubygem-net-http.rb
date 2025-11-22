#####
# Component release information:
#   https://rubygems.org/gems/net-http
#####
component 'rubygem-net-http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.0'
  pkg.sha256sum 'df42c47ce9f9e95ad32a317c97c12f945bc1af365288837ea4ff259876ecb46d'
  pkg.build_requires 'rubygem-uri'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
