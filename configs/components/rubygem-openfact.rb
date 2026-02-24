#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.5.0'
  pkg.sha256sum '20621ef1f923de6cc9e8b900dfb51b9836ef83252098bd1acdcac183ec834fde'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
