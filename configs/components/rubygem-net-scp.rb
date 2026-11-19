#####
# Component release information:
#   https://rubygems.org/gems/net-scp
#   https://github.com/net-ssh/net-scp/tags
#####
component 'rubygem-net-scp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.2.2'
  pkg.sha256sum 'af26fa536fb1fe5a3e77e0095d00685eca58fa49c28968f4fabc52fea21d35a2'
  pkg.build_requires 'rubygem-net-ssh'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
