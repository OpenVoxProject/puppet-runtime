#####
# Component release information:
#   https://rubygems.org/gems/rubyzip
#   https://github.com/rubyzip/rubyzip/releases
#   https://github.com/rubyzip/rubyzip/blob/master/Changelog.md
#####
component 'rubygem-rubyzip' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '3.7.0'
  pkg.sha256sum '65c19294da75297a939006f3516deacc33185fbd721ff1954f7a231db6d3e121'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
