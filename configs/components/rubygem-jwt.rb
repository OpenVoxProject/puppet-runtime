#####
# Component release information:
#   https://rubygems.org/gems/jwt
#   https://github.com/jwt/ruby-jwt/blob/v3.1.2/CHANGELOG.md
# Notes:
#   This seems to only be for the bundled gcloud_inventory module
#   in Bolt, which itself has a dependency of ~> 2.2.1. So probably
#   this isn't even having the effect we want. Should take a look to
#   see if we should just remove this component.
#####
component 'rubygem-jwt' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.7.1'
  pkg.sha256sum '07357cd2f180739b2f8184eda969e252d850ac996ed0a23f616e8ff0a90ae19b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
