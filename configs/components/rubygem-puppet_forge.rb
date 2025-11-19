#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet_forge' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.0.4'
  pkg.sha256sum '0638c7b23165e0641e74edd11a9877d934ec7e7b3196382382f7561b62fec534'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-faraday-follow_redirects'
  pkg.build_requires 'rubygem-minitar'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
