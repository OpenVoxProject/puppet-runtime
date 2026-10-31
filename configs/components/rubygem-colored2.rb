#####
# Component release information:
#   https://rubygems.org/gems/colored2
#   https://github.com/kigster/colored2/releases
#####
component 'rubygem-colored2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.1.0'
  pkg.sha256sum 'ad0dadbc49ecdd8e8859f45d339d63f4101b1941f7ffa5e86cdc46d925a3bb03'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
