#####
# Component release information:
#   https://rubygems.org/gems/faraday-retry
#   https://github.com/lostisland/faraday-retry/releases
#####
component 'rubygem-faraday-retry' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.0'
  pkg.sha256sum '7b79c48fb7e56526faf247b12d94a680071ff40c9fda7cf1ec1549439ad11ebe'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
