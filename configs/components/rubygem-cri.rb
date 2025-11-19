#####
# Component release information:
#   https://rubygems.org/gems/cri
#   https://github.com/denisdefreyne/cri/releases
#####
component 'rubygem-cri' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.15.12'
  pkg.sha256sum '8abfe924ef53e772a8e4ee907e791d3bfcfca78bc62a5859e3b9899ba29956e5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
