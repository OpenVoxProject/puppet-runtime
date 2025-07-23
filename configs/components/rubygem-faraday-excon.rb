#####
# Component release information:
#   https://rubygems.org/gems/faraday-excon
#   https://github.com/excon/faraday-excon/tags
#   https://github.com/excon/faraday-excon/releases
#####
component 'rubygem-faraday-excon' do |pkg, settings, platform|
  pkg.version '1.1.0'
  pkg.md5sum '91d075ce12868a30a520af0588930927'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
