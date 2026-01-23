#####
# Component release information:
#   https://rubygems.org/gems/net-http
#####
component 'rubygem-net-http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.1'
  pkg.sha256sum '25ba0b67c63e89df626ed8fac771d0ad24ad151a858af2cc8e6a716ca4336996'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
