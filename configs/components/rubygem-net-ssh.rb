#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
# Notes:
#   This is pinned as the 8.0.0 release of net-ssh has a >=3.2.0
#   dependency on the openssl gem. Ruby 3.2 ships version 3.1,
#   so updates past 7.3.x fail to install.
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '7.3.8'
  pkg.sha256sum '16bb1fccc4d9a580decdeea8ddb98e8544df29b7e6ac8cb94d4b379cfe4bee9f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
