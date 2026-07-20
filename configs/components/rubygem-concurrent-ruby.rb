#####
# Component release information:
#   https://rubygems.org/gems/concurrent-ruby
#   https://github.com/ruby-concurrency/concurrent-ruby/blob/master/CHANGELOG.md
#####
component 'rubygem-concurrent-ruby' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.8'
  pkg.sha256sum 'b2f1be836e968ccc78ccfce277ea79c72a88633f22306782c16ff23fb415d1e1'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
