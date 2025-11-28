#####
# Component release information:
#   https://rubygems.org/gems/bcrypt_pbkdf
#   https://github.com/net-ssh/bcrypt_pbkdf-ruby/tags
#####
component 'rubygem-bcrypt_pbkdf' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.1'
  pkg.sha256sum '2f9077dde837d1f0dd2eb0f9e5327c6871c68ebc8eba88870fb6b7956e1e2b13'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
