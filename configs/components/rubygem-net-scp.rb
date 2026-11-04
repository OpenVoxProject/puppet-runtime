#####
# Component release information:
#   https://rubygems.org/gems/net-scp
#   https://github.com/net-ssh/net-scp/tags
#####
component 'rubygem-net-scp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.2.1'
  pkg.sha256sum '5c9ff6743da37eef6746f248043d97d2bbf3910a4694ec8e372326ec588c2394'
  pkg.build_requires 'rubygem-net-ssh'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
