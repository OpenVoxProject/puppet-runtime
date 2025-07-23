#####
# Component release information:
#   https://rubygems.org/gems/connection_pool
#   https://github.com/mperham/connection_pool/blob/main/Changes.md
#####
component 'rubygem-connection_pool' do |pkg, settings, platform|
  pkg.version '2.4.1'
  pkg.md5sum 'fd45f00b6d127bb49845afd7f7b91baa'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
