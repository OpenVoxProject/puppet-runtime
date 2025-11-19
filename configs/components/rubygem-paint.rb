#####
# Component release information:
#   https://rubygems.org/gems/paint
#   https://github.com/janlelis/paint/blob/main/CHANGELOG.md
#####
component 'rubygem-paint' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.3.0'
  pkg.sha256sum '327d623e4038619d5bd99ae5db07973859cd78400c7f0329eea283cef8e83be5'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
