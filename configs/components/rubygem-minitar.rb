#####
# Component release information:
#   https://rubygems.org/gems/minitar
#   https://github.com/halostatue/minitar/blob/main/CHANGELOG.md
# Notes:
#   2025-07-23: 1.x changes a namespace, and there are no vulnerability fixes,
#               so leaving this at 0.12.1 for now.
#####
component 'rubygem-minitar' do |pkg, settings, platform|
  pkg.version '0.12.1'
  pkg.md5sum '975dee1dadeb26a2a01105802c3172ab'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
