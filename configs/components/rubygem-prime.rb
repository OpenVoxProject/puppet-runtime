#####
# Component release information:
#   https://rubygems.org/gems/prime
#   https://github.com/ruby/prime/releases
#####
component 'rubygem-prime' do |pkg, settings, platform|
  pkg.version '0.1.4'
  pkg.sha256sum '4d755ebf7c2994a6f3a3fee0d072063be3fff2d4042ebff6cd5eebd4747a225e'

  # Requires 'forwardable' and 'singleton', both part of the Ruby standard library as of 3.2

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
