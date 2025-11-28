#####
# Component release information:
#   https://rubygems.org/gems/multipart-post
#   https://github.com/socketry/multipart-post/releases
#####
component 'rubygem-multipart-post' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.1'
  pkg.sha256sum '9872d03a8e552020ca096adadbf5e3cb1cd1cdd6acd3c161136b8a5737cdb4a8'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
