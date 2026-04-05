#####
# Component release information:
#   https://rubygems.org/gems/public_suffix
#   https://github.com/weppos/publicsuffix-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '7.0.5'
  pkg.sha256sum '1a8bb08f1bbea19228d3bed6e5ed908d1cb4f7c2726d18bd9cadf60bc676f623'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
