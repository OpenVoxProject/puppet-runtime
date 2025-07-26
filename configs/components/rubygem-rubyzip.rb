#####
# Component release information:
#   https://rubygems.org/gems/rubyzip
#   https://github.com/rubyzip/rubyzip/releases
#   https://github.com/rubyzip/rubyzip/blob/master/Changelog.md
#####
component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '2.4.1'
  pkg.sha256sum '8577c88edc1fde8935eb91064c5cb1aef9ad5494b940cf19c775ee833e075615'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
