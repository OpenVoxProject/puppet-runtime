#####
# Component release information:
#   https://rubygems.org/gems/winrm
#   https://github.com/WinRb/WinRM/releases
#####
component 'rubygem-winrm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.9'
  pkg.sha256sum 'ef6b767c5772d06e186300b506ea5e65afb849904a551f8482a5cfc2a1be5d06'
  pkg.build_requires 'rubygem-builder'
  pkg.build_requires 'rubygem-erubi'
  pkg.build_requires 'rubygem-gssapi'
  pkg.build_requires 'rubygem-gyoku'
  pkg.build_requires 'rubygem-httpclient'
  pkg.build_requires 'rubygem-logging'
  pkg.build_requires 'rubygem-nori'
  pkg.build_requires 'rubygem-rexml'
  pkg.build_requires 'rubygem-rubyntlm'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
