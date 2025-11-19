#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.555.0'
  pkg.sha256sum 'e323b6a5f810b97e51fc64befc4c88dba4dfa81c8ebb841907bad4cb7969f92f'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
