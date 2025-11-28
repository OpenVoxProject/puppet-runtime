#####
# Component release information:
#   https://rubygems.org/gems/jmespath
#   https://github.com/jmespath/jmespath.rb/releases
#####
component 'rubygem-jmespath' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.6.2'
  pkg.sha256sum '238d774a58723d6c090494c8879b5e9918c19485f7e840f2c1c7532cf84ebcb1'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
