#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.39'
  pkg.sha256sum '0bbbcd87ffd132824c3f89bbd39deef1ffb3877259090849bd49e48daeaf7b56'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
