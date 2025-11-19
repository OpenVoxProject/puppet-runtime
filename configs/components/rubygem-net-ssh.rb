#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component 'rubygem-net-ssh' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.3.0'
  pkg.sha256sum '172076c4b30ce56fb25a03961b0c4da14e1246426401b0f89cba1a3b54bf3ef0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
