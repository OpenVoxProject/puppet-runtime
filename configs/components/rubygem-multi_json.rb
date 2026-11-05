#####
# Component release information:
#   https://rubygems.org/gems/multi_json
#   https://github.com/sferik/multi_json/blob/main/CHANGELOG.md
#####
component 'rubygem-multi_json' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.21.2'
  pkg.sha256sum '245531eaf54bdba57aba515ff08b4503505c5e09911daa89c5a561e2f85bea8e'
  pkg.build_requires 'rubygem-concurrent-ruby'
  ### End automated maintenance section ###

  # agent-runtime-8.x installs this gem into the vendor gem directory that
  # puppetserver also loads from, under JRuby. multi_json 1.20.0 and later
  # cannot be loaded there. The ruby platform gem installed here has no
  # options_cache/concurrent_store.rb, which the gem requires under JRuby, and
  # those releases need Ruby 3.2 while OpenVox Server 8 runs JRuby 9.4 (Ruby 3.1).
  # Hold the Ruby 3.2 runtime at 1.19.1, the last release that loads on both.
  # Other projects follow the version maintained above.
  # https://github.com/OpenVoxProject/puppet-runtime/issues/333
  if settings[:ruby_version] == '3.2'
    pkg.version '1.19.1'
    pkg.sha256sum '7aefeff8f2c854bf739931a238e4aea64592845e0c0395c8a7d2eea7fdd631b7'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
