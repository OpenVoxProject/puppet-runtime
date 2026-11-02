component 'rubygem-choria-mcorpc-support' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.28.0'
  pkg.sha256sum 'b8f8b41a2fa5a45e361fa0af97333fe0780aee96667a35c88ab724ae932274b1'
  pkg.build_requires 'rubygem-nats-pure'
  pkg.build_requires 'rubygem-systemu'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
