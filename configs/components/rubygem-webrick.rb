#####
# Component release information:
#   https://rubygems.org/gems/webrick
#   https://github.com/ruby/webrick/releases
#####
component 'rubygem-webrick' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.9.2'
  pkg.sha256sum 'beb4a15fc474defed24a3bda4ffd88a490d517c9e4e6118c3edce59e45864131'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
