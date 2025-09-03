#####
# Component release information:
#   https://rubygems.org/gems/thor
#   https://github.com/rails/thor/releases
#####
component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '1.4.0'
  pkg.sha256sum '8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
