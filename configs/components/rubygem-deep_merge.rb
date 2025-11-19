#####
# Component release information:
#   https://rubygems.org/gems/deep_merge
#   https://github.com/danielsdeleo/deep_merge/blob/master/CHANGELOG
#####
component 'rubygem-deep_merge' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.2.2'
  pkg.sha256sum '83ced3a3d7f95f67de958d2ce41b1874e83c8d94fe2ddbff50c8b4b82323563a'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
