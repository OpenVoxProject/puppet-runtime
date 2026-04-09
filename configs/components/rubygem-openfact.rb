#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.6.0'
  pkg.sha256sum '91bb8d23e8c1d132879aa009d2bb04686b78e7d21d29a2d675627cccff123c1d'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
