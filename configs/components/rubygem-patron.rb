#####
# Component release information:
#   https://rubygems.org/gems/patron
#####
component 'rubygem-patron' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.13.4'
  pkg.sha256sum 'c4ae37404a028772541e2f19a71e19be970aa53fdf8a3d70c5a9c1350bab3b09'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
