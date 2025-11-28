#####
# Component release information:
#   https://rubygems.org/gems/forwardable
#####
component 'rubygem-forwardable' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.3.3'
  pkg.sha256sum 'f17df4bd6afa6f46a003217023fe5716ef88ce261f5c4cf0edbdeed6470cafac'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
