#####
# Component release information:
#   https://rubygems.org/gems/multi_json
#   https://github.com/sferik/multi_json/blob/main/CHANGELOG.md
#####
component 'rubygem-multi_json' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.20.1'
  pkg.sha256sum '2f3934e805cc45ef91b551a1f89d0e9191abd06a5e04a2ef09a6a036c452ca6d'
  pkg.build_requires 'rubygem-concurrent-ruby'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
