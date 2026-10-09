#####
# Component release information:
#   https://rubygems.org/gems/net-http
#####
component 'rubygem-net-http' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.10.0'
  pkg.sha256sum '1a2ff6e37a05724973c43f2bf7bf105f59c36a4cd0a7e9b1c021a0a566987c27'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
