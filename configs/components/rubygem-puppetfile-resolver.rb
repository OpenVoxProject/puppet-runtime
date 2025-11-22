#####
# Component release information:
#   https://rubygems.org/gems/puppetfile-resolver
#   https://github.com/glennsarti/puppetfile-resolver/blob/main/CHANGELOG.md
# Notes:
#   Deprecated and needs to be removed.
#####
component 'rubygem-puppetfile-resolver' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.6.3'
  pkg.sha256sum 'd54695251bb62ca033d10bba2d9d91243fff474265d4979f2783259a974634ce'
  pkg.build_requires 'rubygem-molinillo'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
