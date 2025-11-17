#####
# Component release information:
#   https://rubygems.org/gems/rubyntlm
#   https://github.com/WinRb/rubyntlm/releases
#####
component 'rubygem-rubyntlm' do |pkg, settings, platform|
  # Do not update past this version without solving the jruby/ruby2.7 issue described in the commit
  # message this comment is associated with.
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '0.6.3'
  pkg.sha256sum '5b321456dba3130351f7451f8669f1afa83a0d26fd63cdec285b7b88e667102d'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
