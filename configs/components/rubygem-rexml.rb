#####
# Component release information:
#   https://rubygems.org/gems/rexml
#   https://github.com/ruby/rexml/releases
#####
component 'rubygem-rexml' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.4.2'
  pkg.sha256sum '1384268554a37af5da5279431ca3f2f37d46f09ffdd6c95e17cc84c83ea7c417'
  ### End automated maintenance section ###

  settings["#{pkg.get_name}_remove_older_versions".to_sym] = true

  # If the platform is solaris with sparc architecture in agent-runtime-7.x project, we want to gem install rexml
  # ignoring the dependencies, this is because the pl-ruby version used in these platforms is ancient so it gets
  # confused when installing rexml. It tries to install rexml's dependency 'strscan' by building native extensions
  # but fails. We can ignore insalling that since strscan is already shipped with ruby 2 as its default gem.
  settings["#{pkg.get_name}_gem_install_options".to_sym] = '--ignore-dependencies' if platform.name =~ /solaris-(10|11)-sparc/ && settings[:ruby_version].to_i < 3

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
