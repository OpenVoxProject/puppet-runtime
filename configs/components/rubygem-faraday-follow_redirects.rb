#####
# Component release information:
#   https://rubygems.org/gems/faraday-follow_redirects
#   https://github.com/tisba/faraday-follow-redirects/blob/main/CHANGELOG.md
#####
component 'rubygem-faraday-follow_redirects' do |pkg, settings, platform|
  pkg.version '0.3.0'
  pkg.md5sum '75fa678fa40b54a94e51efc1600a6461'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
