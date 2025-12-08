#####
# Component release information:
#   https://rubygems.org/gems/sys-filesystem
#   https://github.com/djberg96/sys-filesystem/blob/main/CHANGES.md
#####
component 'rubygem-sys-filesystem' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.5.5'
  pkg.sha256sum '6f995890a734b9f0aa55df5e09d99adeb9fd1c288f2c4097269a1f8c95e15033'
  pkg.build_requires 'rubygem-ffi'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
