#####
# Component release information:
#   https://rubygems.org/gems/sys-filesystem
#   https://github.com/djberg96/sys-filesystem/blob/main/CHANGES.md
#####
component 'rubygem-sys-filesystem' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.6.0'
  pkg.sha256sum 'e2a7183e147e9b95aaa1217d65b3e3b479861c554acd18ec36aebb91398b45f6'
  pkg.build_requires 'rubygem-ffi'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
