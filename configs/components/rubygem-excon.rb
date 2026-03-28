#####
# Component release information:
#   https://rubygems.org/gems/excon
#####
component 'rubygem-excon' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.4.2'
  pkg.sha256sum '32d8d8eda619717d9b8043b4675e096fb5c2139b080e2ad3b267f88c545aaa35'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
