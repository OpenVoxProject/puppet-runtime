#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '5.7.1'
  pkg.sha256sum 'b67f3f2a00eb383be57fa0f0d8ee9b847b0f661df20eebde97a805c9a6e3e01e'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
