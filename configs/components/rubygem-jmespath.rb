#####
# Component release information:
#   https://rubygems.org/gems/jmespath
#   https://github.com/jmespath/jmespath.rb/releases
#####
component 'rubygem-jmespath' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.6.2'
  pkg.md5sum 'fdd62edafbd40171f976a53ab349ae9e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
