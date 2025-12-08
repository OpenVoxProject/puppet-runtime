#####
# Component release information:
#   https://rubygems.org/gems/bcrypt_pbkdf
#   https://github.com/net-ssh/bcrypt_pbkdf-ruby/tags
#####
component 'rubygem-bcrypt_pbkdf' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.2'
  pkg.sha256sum 'c2414c23ce66869b3eb9f643d6a3374d8322dfb5078125c82792304c10b94cf6'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
