#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.36'
  pkg.md5sum 'ffaaaaafc1257e3bb98aea44fa47c05d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

