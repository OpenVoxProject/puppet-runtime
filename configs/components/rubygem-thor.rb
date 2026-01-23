#####
# Component release information:
#   https://rubygems.org/gems/thor
#   https://github.com/rails/thor/releases
#####
component 'rubygem-thor' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.5.0'
  pkg.sha256sum 'e3a9e55fe857e44859ce104a84675ab6e8cd59c650a49106a05f55f136425e73'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
