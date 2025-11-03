#####
# Component release information:
#   https://rubygems.org/gems/log4r
# Note:
#   Hasn't been updated since 2012. Should probably dump this.
#####
component 'rubygem-log4r' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.10'
  pkg.md5sum '8d54b52c97f9fc17cc20a5277af20402'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
