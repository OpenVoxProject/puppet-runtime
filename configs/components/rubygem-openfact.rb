#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '5.7.2'
  pkg.sha256sum 'e0e83990eebf9e791b7e99a7b96be3762ced6169bd900f8c2b698783be8e6399'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
