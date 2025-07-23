#####
# Component release information:
#   https://rubygems.org/gems/tty-which
#   https://github.com/piotrmurach/tty-which/blob/master/CHANGELOG.md
#####
component "rubygem-tty-which" do |pkg, settings, platform|
  pkg.version "0.5.0"
  pkg.sha256sum "5824055f0d6744c97e7c4426544f01d519c40d1806ef2ef47d9854477993f466"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
