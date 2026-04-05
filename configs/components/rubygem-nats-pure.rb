#####
# Component release information:
#   https://rubygems.org/gems/nats-pure
#   https://github.com/nats-io/nats-pure.rb/blob/main/CHANGELOG.md
# 2026-04-05: Pinned as rubygem-choria-mcorpc-support requires < 0.7.
#   Need to work on updating that gem so we can update this one.
#   https://github.com/OpenVoxProject/puppet-runtime/issues/128#issuecomment-3989498214
#####
component 'rubygem-nats-pure' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '0.6.2'
  pkg.sha256sum '4c8b24466ae4a364ac5e5f066d5045b6825632993a3d39ddd91718c2bc86c1f5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
