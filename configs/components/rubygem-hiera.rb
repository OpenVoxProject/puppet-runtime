#####
# Component release information:
#   https://rubygems.org/gems/hiera
#   https://github.com/puppetlabs/hiera/tags
#####
component 'rubygem-hiera' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.12.0'
  pkg.sha256sum '7808800f6da3ec9bb3b5d63d113a8ccbc3fb4fe72f459d5b67a1ef23ab952b61'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
