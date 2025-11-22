#####
# Component release information:
#   https://rubygems.org/gems/gyoku
#   https://github.com/savonrb/gyoku/blob/main/CHANGELOG.md
#####
component 'rubygem-gyoku' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.4.0'
  pkg.sha256sum '389d887384c777f271cb9377bb642f20bbe0c633d1ef5af78569d4db53c1a2cd'
  pkg.build_requires 'rubygem-builder'
  pkg.build_requires 'rubygem-rexml'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
