#####
# Component release information:
#   https://rubygems.org/gems/faraday-follow_redirects
#   https://github.com/tisba/faraday-follow-redirects/blob/main/CHANGELOG.md
# Notes:
#   2025-12-04: puppet_forge 6.0.0 has faraday-follow_redirects ~> 0.3.0
#####
component 'rubygem-faraday-follow_redirects' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '0.3.0'
  pkg.sha256sum 'd92d975635e2c7fe525dd494fcd4b9bb7f0a4a0ec0d5f4c15c729530fdb807f9'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
