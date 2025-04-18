component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  pkg.version '4.2.0'
  pkg.sha256sum '9285e71bb4861d81cb48f961330ea45126d3a9fe88e8310ddbe7bdc2161ff4b3'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
