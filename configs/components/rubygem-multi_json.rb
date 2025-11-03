#####
# Component release information:
#   https://rubygems.org/gems/multi_json
#   https://github.com/sferik/multi_json/blob/main/CHANGELOG.md
#####
component 'rubygem-multi_json' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.17.0'
  pkg.sha256sum '76581f6c96aebf2e85f8a8b9854829e0988f335e8671cd1a56a1036eb75e4a1b'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
