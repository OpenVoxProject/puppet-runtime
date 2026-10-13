#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.3.6'
  pkg.sha256sum '3364dedce752b9f5221e12ae970880d871a8e733e4730e4b9bd89e0b6808ce4b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
