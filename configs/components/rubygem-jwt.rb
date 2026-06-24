#####
# Component release information:
#   https://rubygems.org/gems/jwt
#   https://github.com/jwt/ruby-jwt/blob/v3.1.2/CHANGELOG.md
# Notes:
#   r10k pins this to < 3, so pinning to the latest 2.x version for now.
#   https://github.com/puppetlabs/r10k/pull/1434
#####
component 'rubygem-jwt' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.10.3'
  pkg.sha256sum 'e4d9352fbc7309b1a7448c7dd713dfe4d8c47077af80759cdbed8f878ea0b484'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
