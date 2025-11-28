#####
# Component release information:
#   https://rubygems.org/gems/fiddle
#   https://github.com/ruby/fiddle/releases
#####
component 'rubygem-fiddle' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.8'
  pkg.sha256sum '7fa8ee3627271497f3add5503acdbc3f40b32f610fc1cf49634f083ef3f32eee'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
