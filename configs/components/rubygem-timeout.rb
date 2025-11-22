#####
# Component release information:
#   https://rubygems.org/gems/timeout
#####
component 'rubygem-timeout' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.4.4'
  pkg.sha256sum 'f0f6f970104b82427cd990680f539b6bbb8b1e55efa913a55c6492935e4e0edb'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
