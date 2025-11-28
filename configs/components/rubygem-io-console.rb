#####
# Component release information:
#   https://rubygems.org/gems/io-console
#####
component 'rubygem-io-console' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.1'
  pkg.sha256sum '1e15440a6b2f67b6ea496df7c474ed62c860ad11237f29b3bd187f054b925fcb'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
