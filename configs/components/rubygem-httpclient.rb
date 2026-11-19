#####
# Component release information:
#   https://rubygems.org/gems/httpclient
#   https://github.com/nahi/httpclient/blob/master/CHANGELOG.md
#####
component 'rubygem-httpclient' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.11.0'
  pkg.sha256sum '9ebadb93fa2815f1916932546db49dc03e85902af04deb2c4a6ddf7bbd54ea89'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
