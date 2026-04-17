#####
# Component release information:
#   https://rubygems.org/gems/multi_json
#   https://github.com/sferik/multi_json/blob/main/CHANGELOG.md
#####
component 'rubygem-multi_json' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  # 1.20.0 introduced a breaking change :melting_face:
  # https://github.com/sferik/multi_json/commit/ca2c747570335f8d3b6b0904aae6ace41329aedd
  pkg.version '1.19.1'
  pkg.sha256sum '7aefeff8f2c854bf739931a238e4aea64592845e0c0395c8a7d2eea7fdd631b7'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
