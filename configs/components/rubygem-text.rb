#####
# Component release information:
#   https://rubygems.org/gems/text
#   https://github.com/threedaymonk/text/tags
#####
component 'rubygem-text' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.1'
  pkg.sha256sum '2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
