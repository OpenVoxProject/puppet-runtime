#####
# Component release information:
#   https://rubygems.org/gems/hiera-eyaml
#   https://github.com/voxpupuli/hiera-eyaml/blob/master/CHANGELOG.md
#####
component 'rubygem-hiera-eyaml' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.0.0'
  pkg.sha256sum 'efdbc2d6d48897fc288047a391403b15c00cdf43de6765903997d4b65ae48895'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-highline'
  pkg.build_requires 'rubygem-optimist'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
