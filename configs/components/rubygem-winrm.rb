#####
# Component release information:
#   https://rubygems.org/gems/winrm
#   https://github.com/WinRb/WinRM/releases
#####
component 'rubygem-winrm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.0'
  pkg.sha256sum '9e210758f5c4d76cbc28ff0b27c082483c91c17dcb6cd44ce3467c08160aa916'
  pkg.build_requires 'rubygem-builder'
  pkg.build_requires 'rubygem-erubi'
  pkg.build_requires 'rubygem-gssapi'
  pkg.build_requires 'rubygem-gyoku'
  pkg.build_requires 'rubygem-httpclient'
  pkg.build_requires 'rubygem-nori'
  pkg.build_requires 'rubygem-rexml'
  pkg.build_requires 'rubygem-rubyntlm'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
