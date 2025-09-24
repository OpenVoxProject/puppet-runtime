#####
# Component release information:
#   https://rubygems.org/gems/highline
#   https://github.com/JEG2/highline/blob/master/Changelog.md
#####
component 'rubygem-highline' do |pkg, settings, _platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '3.1.2'
    pkg.sha256sum '67cbd34d19f6ef11a7ee1d82ffab5d36dfd5b3be861f450fc1716c7125f4bb4a'
  else
    pkg.version '2.1.0'
    pkg.sha256sum 'd63d7f472f8ffaa143725161ae6fb06895b5cb7527e0b4dac5ad1e4902c80cb9'
  end

  # Requires 'reline', part of the Ruby standard library as of 3.2

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
