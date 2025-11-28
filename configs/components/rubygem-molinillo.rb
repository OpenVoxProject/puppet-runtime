#####
# Component release information:
#   https://rubygems.org/gems/molinillo
#   https://github.com/CocoaPods/Molinillo/releases
#   https://github.com/CocoaPods/Molinillo/blob/master/CHANGELOG.md
#####
component 'rubygem-molinillo' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.0'
  pkg.sha256sum 'efbff2716324e2a30bccd3eba1ff3a735f4d5d53ffddbc6a2f32c0ca9433045d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
