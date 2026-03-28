#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet_forge' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.2.0'
  pkg.sha256sum '9cde4841a7a6950afeb0c4fec02449931179863918c0a6e6909cb2a6c6998a0c'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-faraday-follow_redirects'
  pkg.build_requires 'rubygem-minitar'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
