#####
# Component release information:
#   https://rubygems.org/gems/hiera-eyaml
#   https://github.com/voxpupuli/hiera-eyaml/blob/master/CHANGELOG.md
#####
component 'rubygem-hiera-eyaml' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.0.1'
  pkg.sha256sum 'b463fc9aa8f310659251cc7efd8c5db2e0fa893c4bc5b97e07276cb597cb93e6'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-highline'
  pkg.build_requires 'rubygem-optimist'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
