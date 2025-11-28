#####
# Component release information:
#   https://rubygems.org/gems/locale
#   https://github.com/ruby-gettext/locale/releases
#   (Not up to date) https://github.com/ruby-gettext/locale/blob/master/ChangeLog
#####
component 'rubygem-locale' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.1.4'
  pkg.sha256sum '522f9973ef3eee64aac9bca06d21db2fba675fa3d2cf61d21f42d1ca18a9f780'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
