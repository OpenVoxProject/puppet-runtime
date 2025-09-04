#####
# Component release information:
#   https://rubygems.org/gems/fast_gettext
#   https://github.com/grosser/fast_gettext/blob/master/CHANGELOG
#####
component "rubygem-fast_gettext" do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.0
    pkg.version '4.1.0'
    pkg.sha256sum '8e6b612676d601209662d2cd793ed4a067f834c8ca65ede793bacc9bcc1c2763'
  else
    # Remove this when we EOL OpenVox 7.x
    pkg.version '2.4.0'
    pkg.sha256sum 'fd26c4c406aa10be34f0fd2847ce3ffdc1e9d9798de87538594757bbb9175fbf'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
