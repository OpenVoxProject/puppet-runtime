#####
# Component release information:
#   https://rubygems.org/gems/gssapi
#   https://github.com/zenchild/gssapi/tags
#   (Not up to date) https://github.com/zenchild/gssapi/blob/main/Changelog.md
#####
component 'rubygem-gssapi' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.1'
  pkg.sha256sum 'c51cf30842ee39bd93ce7fc33e20405ff8a04cda9dec6092071b61258284aee1'
  pkg.build_requires 'rubygem-ffi'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
