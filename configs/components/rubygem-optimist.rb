#####
# Component release information:
#   https://rubygems.org/gems/optimist
#   https://github.com/ManageIQ/optimist/blob/master/CHANGELOG.md
#####
component 'rubygem-optimist' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.2.1'
  pkg.sha256sum '8cf8a0fd69f3aa24ab48885d3a666717c27bc3d9edd6e976e18b9d771e72e34e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
