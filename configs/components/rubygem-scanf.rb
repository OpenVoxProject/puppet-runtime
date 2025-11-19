#####
# Component release information:
#   https://rubygems.org/gems/scanf
#   https://github.com/ruby/scanf/releases
#####
component 'rubygem-scanf' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.0.0'
  pkg.sha256sum '533db7f7e5acafea1a145d6c5329cef667a58fbcb7d64379a808ff1199ee1b00'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
