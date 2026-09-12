#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.6'
  pkg.sha256sum '1dab5d8b5c4f6f4c01b0878ba094f0aee5d8c197d0f03eaf43d5a176d66ab447'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
