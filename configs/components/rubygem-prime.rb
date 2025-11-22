#####
# Component release information:
#   https://rubygems.org/gems/prime
#   https://github.com/ruby/prime/releases
#####
component 'rubygem-prime' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.1.4'
  pkg.sha256sum '4d755ebf7c2994a6f3a3fee0d072063be3fff2d4042ebff6cd5eebd4747a225e'
  pkg.build_requires 'rubygem-forwardable'
  pkg.build_requires 'rubygem-singleton'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
