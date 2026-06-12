component 'rubygem-choria-mcorpc-support' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.27.0'
  pkg.sha256sum 'b4b148cd673533b8bd42621b834c35c580888d4d527b0c45db8d385068055dd3'
  pkg.build_requires 'rubygem-nats-pure'
  pkg.build_requires 'rubygem-systemu'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
