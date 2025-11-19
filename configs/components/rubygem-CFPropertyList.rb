#####
# Component release information:
#   https://rubygems.org/gems/CFPropertyList
#   https://github.com/ckruse/CFPropertyList/tags
# Notes:
#   - 2025-11-03: Removed pinning agent-runtime-7.x to 2.x since CFPropertList 3.x dropped support
#     for Ruby 1.8, and the latest should still work on 2.7.
#####
component 'rubygem-CFPropertyList' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.0.7'
  pkg.md5sum 'ed89ce5e7074a6f8e8b8e744eaf014d0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment 'GEM_HOME', settings[:gem_home]
end
