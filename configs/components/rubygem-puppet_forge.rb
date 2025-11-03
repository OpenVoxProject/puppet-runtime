#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
# Notes:
#   2025-07-23: Leaving this at 5.x for now since 6.x requires the new
#               minitar gem, which OpenVox also uses. Need to fix it up
#               in the agent before bumping this.
#####
component 'rubygem-puppet_forge' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '5.0.4'
  pkg.md5sum '04a2ca2f027ed41d9142ced587b71bd7'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
