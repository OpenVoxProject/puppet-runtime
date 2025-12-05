#####
# Component release information:
#   https://rubygems.org/gems/ruby-dbus
#####
component 'rubygem-ruby-dbus' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.25.0'
  pkg.sha256sum 'fe431ca96a61f7c87a5177a43c9fe0a50eafe174c1d108421e38bb5165ea4814'
  pkg.build_requires 'rubygem-logger'
  pkg.build_requires 'rubygem-rexml'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
