#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet_forge' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.0.0'
  pkg.sha256sum '0770bed61c9f5b21bd81666b121e086165e34c45691bdefec70438bf412f8ddf'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-faraday-follow_redirects'
  pkg.build_requires 'rubygem-minitar'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
