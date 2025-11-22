#####
# Component release information:
#   https://rubygems.org/gems/highline
#   https://github.com/JEG2/highline/blob/master/Changelog.md
#####
component 'rubygem-highline' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.1.2'
  pkg.sha256sum '67cbd34d19f6ef11a7ee1d82ffab5d36dfd5b3be861f450fc1716c7125f4bb4a'
  pkg.build_requires 'rubygem-reline'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
