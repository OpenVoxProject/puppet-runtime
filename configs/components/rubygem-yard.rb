#####
# Component release information:
#   https://rubygems.org/gems/yard
#   https://github.com/lsegal/yard/releases
#####
component 'rubygem-yard' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.9.38'
  pkg.sha256sum '721fb82afb10532aa49860655f6cc2eaa7130889df291b052e1e6b268283010f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
