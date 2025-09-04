#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.37'
  pkg.sha256sum 'a6e910399e78e613f80ba9add9ba7c394b1a935f083cccbef82903a3d2a26992'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

