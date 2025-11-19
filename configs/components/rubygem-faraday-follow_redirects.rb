#####
# Component release information:
#   https://rubygems.org/gems/faraday-follow_redirects
#   https://github.com/tisba/faraday-follow-redirects/blob/main/CHANGELOG.md
#####
component 'rubygem-faraday-follow_redirects' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.4.0'
  pkg.sha256sum 'd3fa1118ab1350e24035a272b4cff64948643bb7182846db89acaf87abadd5d9'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
