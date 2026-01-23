#####
# Component release information:
#   https://rubygems.org/gems/public_suffix
#   https://github.com/weppos/publicsuffix-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.0.2'
  pkg.sha256sum '9114090c8e4e7135c1fd0e7acfea33afaab38101884320c65aaa0ffb8e26a857'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
