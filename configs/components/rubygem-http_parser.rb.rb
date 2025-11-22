#####
# Component release information:
#   https://rubygems.org/gems/http_parser.rb
#####
component 'rubygem-http_parser.rb' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.0'
  pkg.sha256sum '5a0932f1fa82ce08a8516a2685d5a86031c000560f89946913c555a0697544be'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
