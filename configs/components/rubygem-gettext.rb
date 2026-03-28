#####
# Component release information:
#   https://rubygems.org/gems/gettext
#   https://github.com/ruby-gettext/gettext/releases
#####
component 'rubygem-gettext' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.5.2'
  pkg.sha256sum 'ada02c59aa7e9f56bd2522faedaed16421dd2f3ddb5fe28628c0be5abcbf3c74'
  pkg.build_requires 'rubygem-erubi'
  pkg.build_requires 'rubygem-locale'
  pkg.build_requires 'rubygem-text'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  gem_home = settings[:puppet_gem_vendor_dir] || settings[:gem_home]
  pkg.environment 'GEM_HOME', gem_home
end
