component "rubygem-semantic_puppet" do |pkg, settings, platform|
  version = settings[:rubygem_semantic_puppet_version] || '1.1.1'
  if platform.is_cross_compiled? && platform.is_solaris?
    # solaris 10/11 sparc are failing in agent-runtime-7.x installing semantic_puppet because the gem requires ruby >= 2.7.0
    # when cross compiling on sparc, we use ancient pl-ruby or equivalent. For these older platforms, use older semantic_puppet
    version = '1.0.4'
  end
  pkg.version version

  case version
  when '1.0.4'
    pkg.sha256sum "5d8380bf733c1552ef77e06a7c44a6d5b48def7d390ecf3bd71cad477f5ce13d"
  when '1.1.1'
    pkg.sha256sum "15ff5b48d7f856549eb66b927a8894d3668b211970c9d7dc07dd4db57f5c7a96"
  else
    raise "rubygem-semantic_puppet version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
