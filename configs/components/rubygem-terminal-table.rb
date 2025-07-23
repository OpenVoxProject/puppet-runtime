#####
# Component release information:
#   https://rubygems.org/gems/terminal-table
#   https://github.com/tj/terminal-table/releases
#####
component 'rubygem-terminal-table' do |pkg, settings, platform|
  pkg.version '4.0.0'
  pkg.sha256sum 'f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
