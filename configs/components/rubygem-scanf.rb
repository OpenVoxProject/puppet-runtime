#####
# Component release information:
#   https://rubygems.org/gems/scanf
#   https://github.com/ruby/scanf/releases
#####
component 'rubygem-scanf' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.0.0'
  pkg.md5sum '6a48b02b5d7109331afa8bd9d55a802e'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
