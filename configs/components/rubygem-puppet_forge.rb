#####
# Component release information:
#   https://rubygems.org/gems/puppet_forge
#   https://github.com/puppetlabs/forge-ruby/releases
#   https://github.com/puppetlabs/forge-ruby/blob/main/CHANGELOG.md
#####
component 'rubygem-puppet_forge' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '6.1.0'
  pkg.sha256sum 'e3bfe83282f0136adf0938f52180a53b45434b70464a5a453d6398df6563764b'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-faraday'
  pkg.build_requires 'rubygem-faraday-follow_redirects'
  pkg.build_requires 'rubygem-minitar'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
