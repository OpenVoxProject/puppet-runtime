#####
# Component release information:
#   https://rubygems.org/gems/winrm-fs
#   https://github.com/WinRb/winrm-fs/tags
#####
component 'rubygem-winrm-fs' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.7'
  pkg.sha256sum '90317105577b8ab1b5c5cc90b414f5052a0a291d56000793e5e2fd31b009e05f'
  pkg.build_requires 'rubygem-rubyzip'
  pkg.build_requires 'rubygem-winrm'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
