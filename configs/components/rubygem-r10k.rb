#####
# Component release information:
#   https://rubygems.org/gems/r10k
#   https://github.com/puppetlabs/r10k/blob/main/CHANGELOG.mkd
#####
component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '5.0.2'
  pkg.sha256sum '48e24e2b8447cdc56b03303b741247a5255bb40f170c9d113c5d3dbd8c83e8b3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
