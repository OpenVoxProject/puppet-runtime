#####
# Component release information:
#   https://rubygems.org/gems/net-scp
#   https://github.com/net-ssh/net-scp/tags
#####
component 'rubygem-net-scp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.1.0'
  pkg.sha256sum 'a99b0b92a1e5d360b0de4ffbf2dc0c91531502d3d4f56c28b0139a7c093d1a5d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
