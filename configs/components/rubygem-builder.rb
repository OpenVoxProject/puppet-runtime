#####
# Component release information:
#   https://rubygems.org/gems/builder
#   https://github.com/rails/builder/blob/master/CHANGES
#####
component 'rubygem-builder' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.3.0'
  pkg.sha256sum '497918d2f9dca528fdca4b88d84e4ef4387256d984b8154e9d5d3fe5a9c8835f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
