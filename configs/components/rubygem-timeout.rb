#####
# Component release information:
#   https://rubygems.org/gems/timeout
#####
component 'rubygem-timeout' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.0'
  pkg.sha256sum '852aefd13f41d84c2d0d83099b275034c6517395884b58e635acc8847c9190cb'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
