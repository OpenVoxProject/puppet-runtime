#####
# Component release information:
#   https://rubygems.org/gems/semantic_puppet
#   https://github.com/puppetlabs/semantic_puppet/blob/main/CHANGELOG.md
#####
component 'rubygem-semantic_puppet' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.1'
  pkg.sha256sum '15ff5b48d7f856549eb66b927a8894d3668b211970c9d7dc07dd4db57f5c7a96'
  ### End automated maintenance section ###
  
  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
