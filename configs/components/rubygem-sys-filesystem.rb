#####
# Component release information:
#   https://rubygems.org/gems/sys-filesystem
#   https://github.com/djberg96/sys-filesystem/blob/main/CHANGES.md
#####
component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  if platform.is_solaris?
    pkg.version '1.4.5'
    pkg.sha256sum '1b61da4ace0f71fc4304126acf005fb8cd03677081bb352343199fddc9eaa56d'
  else
    pkg.version '1.5.3'
    pkg.sha256sum '17b561d1be683c34bc53946461ea9d67012d8f395e7297db8c63b9018cb30ece'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
