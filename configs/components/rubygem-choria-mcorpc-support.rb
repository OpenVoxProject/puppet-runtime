component 'rubygem-choria-mcorpc-support' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.27.0'
  pkg.build_requires 'git'
  pkg.build_requires 'rubygem-nats-pure'
  pkg.build_requires 'rubygem-systemu'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Test build from the head of main instead of the released gem
  pkg.url 'https://github.com/choria-io/choria-mcorpc-support.git'
  pkg.ref 'main'
  pkg.build do
    git_safe_directory = 'GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.directory GIT_CONFIG_VALUE_0="$${PWD}"'
    ["#{git_safe_directory} #{settings[:host_gem]} build choria-mcorpc-support.gemspec"]
  end
end
