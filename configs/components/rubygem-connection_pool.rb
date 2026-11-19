#####
# Component release information:
#   https://rubygems.org/gems/connection_pool
#   https://github.com/mperham/connection_pool/blob/main/Changes.md
#####
component 'rubygem-connection_pool' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.0.3'
  pkg.sha256sum 'e0f8ee3ee0039396753e06e8a2dde0ef028e40f7df29e97f57da7577c489cb5e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
