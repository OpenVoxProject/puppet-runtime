#####
# Component release information:
#   https://rubygems.org/gems/connection_pool
#   https://github.com/mperham/connection_pool/blob/main/Changes.md
# Notes:
#   2025-09-03: 2.5.0 changes behavior to reap idle connections after 60 seconds by default.
#   We need to test this before upgrading to ensure it doesn't break anything or
#   affect performance. There are no security fixes between 2.4.1 and 2.5.4.
#####
component 'rubygem-connection_pool' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.4.1'
  pkg.md5sum 'fd45f00b6d127bb49845afd7f7b91baa'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
