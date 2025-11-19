#####
# Component release information:
#   https://rubygems.org/gems/benchmark
#####
component 'rubygem-benchmark' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.0'
  pkg.sha256sum 'd4ef40037bba27f03b28013e219b950b82bace296549ec15a78016552f8d2cce'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
