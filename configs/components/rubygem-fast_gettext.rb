#####
# Component release information:
#   https://rubygems.org/gems/fast_gettext
#   https://github.com/grosser/fast_gettext/blob/master/CHANGELOG
# 2025-09-08: We must keep this at 2.4.0 for now because r10k
#   relies on gettext-setup, which pins fast_gettext ~> 2.1.
#####
component "rubygem-fast_gettext" do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.4.0'
  pkg.sha256sum 'fd26c4c406aa10be34f0fd2847ce3ffdc1e9d9798de87538594757bbb9175fbf'
  pkg.build_requires 'rubygem-prime'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
