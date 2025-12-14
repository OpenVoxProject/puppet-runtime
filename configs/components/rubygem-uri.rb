#####
# Component release information:
#   https://rubygems.org/gems/uri
# Notes:
#   2025-12-14: This is a default gem, and is only included here to address
#   CVE-2025-61594. This component should be removed once Ruby 3.2.10 is released.
#####
component 'rubygem-uri' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '0.12.5'
  pkg.sha256sum '883424e272244f029ad3b9fe0e9ad18d1c33cdadff0a366c301ce737c62eb414'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
