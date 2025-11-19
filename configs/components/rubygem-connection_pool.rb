#####
# Component release information:
#   https://rubygems.org/gems/connection_pool
#   https://github.com/mperham/connection_pool/blob/main/Changes.md
# Notes:
#   2025-09-03: 2.5.0 changes behavior to reap idle connections after 60 seconds by default.
#   We need to test this before upgrading to ensure it doesn't break anything or
#   affect performance. There are no security fixes between 2.4.1 and 2.5.4.
#####
component 'rubygem-connection_pool' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '2.4.1'
  pkg.sha256sum '0f40cf997091f1f04ff66da67eabd61a9fe0d4928b9a3645228532512fab62f4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
