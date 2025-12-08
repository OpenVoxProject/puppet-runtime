#####
# Component release information:
#   https://rubygems.org/gems/public_suffix
#   https://github.com/weppos/publicsuffix-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.0.0'
  pkg.sha256sum 'f7090b5beb0e56f9f10d79eed4d5fbe551b3b425da65877e075dad47a6a1b095'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
