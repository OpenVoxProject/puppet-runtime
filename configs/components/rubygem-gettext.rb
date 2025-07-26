#####
# Component release information:
#   https://rubygems.org/gems/gettext
#   https://github.com/ruby-gettext/gettext/releases
#####
component "rubygem-gettext" do |pkg, settings, platform|
  pkg.version '3.5.1'
  pkg.sha256sum '03ec7f71ea7e2cf1fdcd5e08682e98b81601922fdbee890b7bc6f63b0e1a512a'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  gem_home = settings[:puppet_gem_vendor_dir] || settings[:gem_home]
  pkg.environment "GEM_HOME", gem_home
end
