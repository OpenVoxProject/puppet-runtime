#####
# Component release information:
#   https://rubygems.org/gems/io-console
#####
component 'rubygem-io-console' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.2'
  pkg.sha256sum 'd6e3ae7a7cc7574f4b8893b4fca2162e57a825b223a177b7afa236c5ef9814cc'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
