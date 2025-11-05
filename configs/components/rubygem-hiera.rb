#####
# Component release information:
#   https://rubygems.org/gems/hiera
#   https://github.com/puppetlabs/hiera/tags
#####
component 'rubygem-hiera' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.12.0'
  pkg.md5sum '67249a25571c9ee83cdb68579faf3f0d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
