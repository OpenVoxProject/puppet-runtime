#####
# Component release information:
#   https://rubygems.org/gems/concurrent-ruby
#   https://github.com/ruby-concurrency/concurrent-ruby/blob/master/CHANGELOG.md
#####
component 'rubygem-concurrent-ruby' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.7'
  pkg.sha256sum '4412caec3a5ea2e5fdc52076724c071a81f2c0593d83b2ac8cbb8ca63b3151b0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
