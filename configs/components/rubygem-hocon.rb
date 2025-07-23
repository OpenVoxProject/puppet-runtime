#####
# Component release information:
#   https://rubygems.org/gems/hocon
#   https://github.com/puppetlabs/ruby-hocon/tags
#   (Not up to date) https://github.com/puppetlabs/ruby-hocon/blob/main/HISTORY.md
#   (Not up to date) https://github.com/puppetlabs/ruby-hocon/releases
#####
component "rubygem-hocon" do |pkg, settings, platform|
  pkg.version '1.4.0'
  pkg.sha256sum "e71023ed7c56ae780ec34c0ce7789a233bcead08c045d50bc7b3af40f5afcd80"
  
  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
