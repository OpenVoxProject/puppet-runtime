#####
# Component release information:
#   https://rubygems.org/gems/ruby_smb
#   https://github.com/rapid7/ruby_smb/tags
# Notes:
#   This is horrifically out of date. Need to try updating it carefully
#   and make sure this doesn't break Bolt SMB support.
#####
component 'rubygem-ruby_smb' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '1.1.0'
  pkg.sha256sum 'c4692ec8983f492161239d36a743b2a8cd309d4523c832a71de14ead6a8db788'
  pkg.build_requires 'rubygem-bindata'
  pkg.build_requires 'rubygem-rubyntlm'
  pkg.build_requires 'rubygem-windows_error'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
