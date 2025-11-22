#####
# Component release information:
#   https://rubygems.org/gems/benchmark
#####
component 'rubygem-benchmark' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.0'
  pkg.sha256sum '465df122341aedcb81a2a24b4d3bd19b6c67c1530713fd533f3ff034e419236c'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
