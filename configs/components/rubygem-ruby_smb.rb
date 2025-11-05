#####
# Component release information:
#   https://rubygems.org/gems/ruby_smb
#   https://github.com/rapid7/ruby_smb/tags
# Notes:
#   This is horrifically out of date. Need to try updating it carefully
#   and make sure this doesn't break Bolt SMB support.
#####
component 'rubygem-ruby_smb' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '1.1.0'
  pkg.md5sum 'f926be4cb045b5984d02dc10e2b240ca'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
