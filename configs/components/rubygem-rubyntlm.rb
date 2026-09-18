#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.8'
  pkg.sha256sum '054aa45ffcae40db4020d3e41da41f40427aa8733181a2b87751f04ba53ca0d5'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
