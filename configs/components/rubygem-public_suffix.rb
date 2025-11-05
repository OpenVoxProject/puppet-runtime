#####
# Component release information:
#   https://rubygems.org/gems/public_suffix
#   https://github.com/weppos/publicsuffix-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-public_suffix' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.0.2'
  pkg.sha256sum 'bfa7cd5108066f8c9602e0d6d4114999a5df5839a63149d3e8b0f9c1d3558394'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
