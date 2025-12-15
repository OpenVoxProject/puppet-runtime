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
  pkg.version '4.0.0'
  pkg.sha256sum '385e7bbd7c27e176b23415275ca936ca0ece1727e5b890b08e36632076b00aff'
  pkg.build_requires 'rubygem-base64'
  pkg.build_requires 'rubygem-rexml'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment 'GEM_HOME', settings[:gem_home]
end
