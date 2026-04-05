#####
# Component release information:
#   https://rubygems.org/gems/r10k
#   https://github.com/puppetlabs/r10k/blob/main/CHANGELOG.mkd
#####
component 'rubygem-r10k' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.0.3'
  pkg.sha256sum 'a76daddd8cecdc1cf0816f3d19adb23782598d373344a9de23623f601d58a68b'
  pkg.build_requires 'rubygem-colored2'
  pkg.build_requires 'rubygem-cri'
  pkg.build_requires 'rubygem-gettext-setup'
  pkg.build_requires 'rubygem-jwt'
  pkg.build_requires 'rubygem-log4r'
  pkg.build_requires 'rubygem-minitar'
  pkg.build_requires 'rubygem-multi_json'
  pkg.build_requires 'rubygem-puppet_forge'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
