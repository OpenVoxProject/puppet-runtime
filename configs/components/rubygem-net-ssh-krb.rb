#####
# Component release information:
#   https://rubygems.org/gems/net-ssh-krb
#   https://github.com/cbeer/net-ssh-kerberos/releases
#####
component 'rubygem-net-ssh-krb' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.1'
  pkg.sha256sum '0c1448f32d7b1dc4decc5e2bb329f38c502c9fed6fb16122b257e5dc8cb61588'
  pkg.build_requires 'rubygem-gssapi'
  pkg.build_requires 'rubygem-net-ssh'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
