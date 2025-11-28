#####
# Component release information:
#   https://rubygems.org/gems/ruby2_keywords
#   https://github.com/ruby/ruby2_keywords/releases
#####
component 'rubygem-ruby2_keywords' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.0.5'
  pkg.sha256sum 'ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
