#####
# Component release information:
#   https://rubygems.org/gems/sys-filesystem
#   https://github.com/djberg96/sys-filesystem/blob/main/CHANGES.md
#####
component 'rubygem-sys-filesystem' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.5.4'
  pkg.sha256sum 'a6101674a4d0e641b0f628753439091134e080ed84a3e794570aa2fb07872b45'
  pkg.build_requires 'rubygem-ffi'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
