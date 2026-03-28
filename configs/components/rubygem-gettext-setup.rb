#####
# Component release information:
#   https://rubygems.org/gems/gettext-setup
#   https://github.com/puppetlabs/gettext-setup-gem/tags
#####
component 'rubygem-gettext-setup' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1.1'
  pkg.sha256sum '15ce653696283c9835b0ad9f02f236b9f240cb35facd3341cc62b85d42c6b667'
  pkg.build_requires 'rubygem-fast_gettext'
  pkg.build_requires 'rubygem-gettext'
  pkg.build_requires 'rubygem-locale'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
