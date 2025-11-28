#####
# Component release information:
#   https://rubygems.org/gems/winrm-fs
#   https://github.com/WinRb/winrm-fs/tags
#####
component 'rubygem-winrm-fs' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.5'
  pkg.sha256sum '0d2cdd9e1fb6fc8d01f56a32dce41d98ae6eefb481937ed0e058faa0cd0c693d'
  pkg.build_requires 'rubygem-erubi'
  pkg.build_requires 'rubygem-logging'
  pkg.build_requires 'rubygem-rubyzip'
  pkg.build_requires 'rubygem-winrm'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
