#####
# Component release information:
#   https://rubygems.org/gems/nats-pure
#   https://github.com/nats-io/nats-pure.rb/blob/main/CHANGELOG.md
#####
component 'rubygem-nats-pure' do |pkg, _settings, _platform|
  # WARNING Update ahead
  # You shall not update beyond 0.6.0, because that is what bundler determined
  # https://github.com/OpenVoxProject/puppet-runtime/issues/128#issuecomment-3989498214
  ### Maintained by update_gems automation ###
  pkg.version '2.5.0'
  pkg.sha256sum '95e03c6aa6afaa33c6938928a04efbef8474844b11c95c8219c1c397ce030a4a'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-concurrent-ruby'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
