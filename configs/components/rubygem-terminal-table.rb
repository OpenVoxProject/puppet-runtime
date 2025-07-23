#####
# Component release information:
#   https://rubygems.org/gems/terminal-table
#   https://github.com/tj/terminal-table/releases
#####
component 'rubygem-terminal-table' do |pkg, settings, platform|
  pkg.version '3.0.2'
  pkg.md5sum '3916a3147871d6421688e575d5939e12'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
