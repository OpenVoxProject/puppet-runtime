#####
# Component release information:
#   https://rubygems.org/gems/http_parser.rb
#####
component 'rubygem-http_parser.rb' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.8.1'
  pkg.sha256sum '9ae8df145b39aa5398b2f90090d651c67bd8e2ebfe4507c966579f641e11097a'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
