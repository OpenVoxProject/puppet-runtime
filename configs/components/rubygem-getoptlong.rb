#####
# Component release information:
#   https://rubygems.org/gems/getoptlong
#####
component 'rubygem-getoptlong' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.2.1'
  pkg.sha256sum 'fd23f07397b994bf9310d4531cfdb4332629a9b8e8c9c457c32b7edf5bf21ba5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
