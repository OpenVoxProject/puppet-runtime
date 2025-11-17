#####
# Component release information:
#   https://rubygems.org/gems/facter
#####
component 'rubygem-facter' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.10.0'
  pkg.sha256sum 'b78a213b9160cded7ab93e7c47c003c618ebd49c6eca549d09a068e27a30a59d'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
