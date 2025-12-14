#####
# Component release information:
#   https://rubygems.org/gems/concurrent-ruby
#   https://github.com/ruby-concurrency/concurrent-ruby/blob/master/CHANGELOG.md
#####
component 'rubygem-concurrent-ruby' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.6'
  pkg.sha256sum '6b56837e1e7e5292f9864f34b69c5a2cbc75c0cf5338f1ce9903d10fa762d5ab'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
