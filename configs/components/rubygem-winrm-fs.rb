#####
# Component release information:
#   https://rubygems.org/gems/winrm-fs
#   https://github.com/WinRb/winrm-fs/tags
#####
component 'rubygem-winrm-fs' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.5'
  pkg.md5sum 'dcde27a3aff684b8277c069cd4b2efe7'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
