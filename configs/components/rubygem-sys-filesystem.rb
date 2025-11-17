#####
# Component release information:
#   https://rubygems.org/gems/sys-filesystem
#   https://github.com/djberg96/sys-filesystem/blob/main/CHANGES.md
#####
component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.5.3'
  pkg.sha256sum '17b561d1be683c34bc53946461ea9d67012d8f395e7297db8c63b9018cb30ece'
  pkg.build_requires 'rubygem-ffi'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
