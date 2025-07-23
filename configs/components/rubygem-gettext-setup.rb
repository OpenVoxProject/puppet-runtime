#####
# Component release information:
#   https://rubygems.org/gems/gettext-setup
#   https://github.com/puppetlabs/gettext-setup-gem/tags
#####
component "rubygem-gettext-setup" do |pkg, settings, platform|
  pkg.version '1.1.0'
  pkg.sha256sum '2ad4fa99575d869f18056941d98dc9cb2a656abc7b991f360fbd3e32d28fd4ec'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
