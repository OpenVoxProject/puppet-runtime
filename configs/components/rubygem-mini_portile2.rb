#####
# Component release information:
#   https://rubygems.org/gems/mini_portile2
#   https://github.com/flavorjones/mini_portile/blob/main/CHANGELOG.md
#####
component 'rubygem-mini_portile2' do |pkg, _settings, _platform|
  pkg.version '2.8.9'
  pkg.sha256sum '0cd7c7f824e010c072e33f68bc02d85a00aeb6fce05bb4819c03dfd3c140c289'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment 'GEM_HOME', settings[:gem_home]
end
