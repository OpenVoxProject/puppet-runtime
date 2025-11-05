#####
# Component release information:
#   https://rubygems.org/gems/net-ssh-krb
#   https://github.com/cbeer/net-ssh-kerberos/releases
#####
component 'rubygem-net-ssh-krb' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.1'
  pkg.md5sum '58f770a6a8eca61b5da467d584bb7016'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
