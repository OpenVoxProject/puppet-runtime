component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  # 1.5.x removes support for Solaris
  pkg.version '1.4.5'
  pkg.sha256sum '1b61da4ace0f71fc4304126acf005fb8cd03677081bb352343199fddc9eaa56d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
