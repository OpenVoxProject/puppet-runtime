#####
# Component release information:
#   https://rubygems.org/gems/httpclient
#   https://github.com/nahi/httpclient/blob/master/CHANGELOG.md
#####
component 'rubygem-httpclient' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.10.0'
  pkg.sha256sum '8c10f65a5e618b9e1c37dc95fccec9e84953b74748257f65930c68c6f221a4ed'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
