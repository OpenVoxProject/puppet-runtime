#####
# Component release information:
#   https://rubygems.org/gems/concurrent-ruby
#   https://github.com/ruby-concurrency/concurrent-ruby/blob/master/CHANGELOG.md
#####
component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.3.5'
  pkg.sha256sum '813b3e37aca6df2a21a3b9f1d497f8cbab24a2b94cab325bffe65ee0f6cbebc6'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
