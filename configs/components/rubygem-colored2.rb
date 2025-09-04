#####
# Component release information:
#   https://rubygems.org/gems/colored2
#   https://github.com/kigster/colored2/releases
#####
component 'rubygem-colored2' do |pkg, settings, platform|
  pkg.version '4.0.3'
  pkg.sha256sum '63e1038183976287efc43034f5cca17fb180b4deef207da8ba78d051cbce2b37'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
