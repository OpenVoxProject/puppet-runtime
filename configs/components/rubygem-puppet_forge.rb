#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet_forge' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.0.4'
  pkg.md5sum '04a2ca2f027ed41d9142ced587b71bd7'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
