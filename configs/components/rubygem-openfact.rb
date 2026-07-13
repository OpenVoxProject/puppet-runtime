#####
# Component release information:
#   https://rubygems.org/gems/openfact
#   https://github.com/OpenVoxProject/openfact/releases
#####
component 'rubygem-openfact' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '5.7.0'
  pkg.sha256sum 'f540d77d93259d410a19e6aebc61f81e78e63c275f8eb01ffb832fdfc87f298c'
  pkg.build_requires 'rubygem-base64' if settings[:ruby_version] == '3.2'
  pkg.build_requires 'rubygem-hocon'
  pkg.build_requires 'rubygem-thor'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
