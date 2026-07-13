#####
# Component release information:
#   https://rubygems.org/gems/windows_error
#   https://github.com/rapid7/windows_error/tags
#####
component 'rubygem-windows_error' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.1.6'
  pkg.sha256sum '6fcb0addc8c779e4f5ce70f5f65babbf586ce5cfb6e7a63604e611a89d34911b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
