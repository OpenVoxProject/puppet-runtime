#####
# Component release information:
#   https://rubygems.org/gems/ruby2_keywords
#   https://github.com/ruby/ruby2_keywords/releases
#####
component 'rubygem-ruby2_keywords' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.0.5'
  pkg.md5sum '89bc1e9231e63a0f93599772ae871e03'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
