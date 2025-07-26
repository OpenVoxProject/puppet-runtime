#####
# Component release information:
#   https://rubygems.org/gems/hiera-eyaml
#   https://github.com/voxpupuli/hiera-eyaml/blob/master/CHANGELOG.md
#####
component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  pkg.version '4.3.0'
  pkg.sha256sum '19eba2ea9d70b2d56de064df9e3242860d8070d47ff9c9a6348b7fe94708ab0a'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
