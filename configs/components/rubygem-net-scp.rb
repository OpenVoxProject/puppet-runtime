#####
# Component release information:
#   https://rubygems.org/gems/net-scp
#   https://github.com/net-ssh/net-scp/tags
#####
component 'rubygem-net-scp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.2.0'
  pkg.sha256sum '7c85a88bcf975def58f35ffa1ea83345f018e368c97aa3b78a4fd116f4a9cd49'
  pkg.build_requires 'rubygem-net-ssh'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
