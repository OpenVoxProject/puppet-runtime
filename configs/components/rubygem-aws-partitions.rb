#####
# Component release information:
#   https://rubygems.org/gems/aws-partitions
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-partitions/CHANGELOG.md
#####
component 'rubygem-aws-partitions' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.1303.0'
  pkg.sha256sum '4debb9488e514ab87ee68cf55184cb8db9bd0256668883c3fe6e8bb76f32929c'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
