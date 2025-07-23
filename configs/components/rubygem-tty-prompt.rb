#####
# Component release information:
#   https://rubygems.org/gems/tty-prompt
#   https://github.com/piotrmurach/tty-prompt/blob/master/CHANGELOG.md
#####
component "rubygem-tty-prompt" do |pkg, settings, platform|
  pkg.version "0.23.1"
  pkg.sha256sum "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
