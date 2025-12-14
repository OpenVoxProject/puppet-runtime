#####
# Component release information:
#   https://rubygems.org/gems/date
#####
component 'rubygem-date' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '3.5.1'
  pkg.sha256sum '750d06384d7b9c15d562c76291407d89e368dda4d4fff957eb94962d325a0dc0'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
