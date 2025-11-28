#####
# Component release information:
#   https://rubygems.org/gems/rubyzip
#   https://github.com/rubyzip/rubyzip/releases
#   https://github.com/rubyzip/rubyzip/blob/master/Changelog.md
#####
component 'rubygem-rubyzip' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.2.2'
  pkg.sha256sum 'c0ed99385f0625415c8f05bcae33fe649ed2952894a95ff8b08f26ca57ea5b3c'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
