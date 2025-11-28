#####
# Component release information:
#   https://rubygems.org/gems/jwt
#   https://github.com/jwt/ruby-jwt/blob/v3.1.2/CHANGELOG.md
# Notes:
#   r10k pins this to < 3, so pinning to the latest 2.x version for now.
#####
component 'rubygem-jwt' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.10.2'
  pkg.sha256sum '31e1ee46f7359883d5e622446969fe9c118c3da87a0b1dca765ce269c3a0c4f4'
  pkg.build_requires 'rubygem-base64'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
