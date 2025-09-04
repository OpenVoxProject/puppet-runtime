#####
# Component release information:
#   https://rubygems.org/gems/webrick
#   https://github.com/ruby/webrick/releases
#####
component 'rubygem-webrick' do |pkg, settings, platform|
  pkg.version '1.9.1'
  pkg.sha256sum 'b42d3c94f166f3fb73d87e9b359def9b5836c426fc8beacf38f2184a21b2a989'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
