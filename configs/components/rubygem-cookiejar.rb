#####
# Component release information:
#   https://rubygems.org/gems/cookiejar
#####
component 'rubygem-cookiejar' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.3.4'
  pkg.sha256sum '11b16acfc4baf7a0f463c21a6212005e04e25f5554d4d9f24d97f3492dfda0df'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
