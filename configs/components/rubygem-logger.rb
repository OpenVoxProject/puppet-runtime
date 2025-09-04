#####
# Component release information:
#   https://rubygems.org/gems/logger
#   https://github.com/ruby/logger/releases
#####
component 'rubygem-logger' do |pkg, settings, platform|
  pkg.version '1.7.0'
  pkg.sha256sum '196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
