#####
# Component release information:
#   https://rubygems.org/gems/patron
#####
component 'rubygem-patron' do |pkg, _settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.13.4'
  pkg.sha256sum 'c4ae37404a028772541e2f19a71e19be970aa53fdf8a3d70c5a9c1350bab3b09'
  ### End automated maintenance section ###

  # Because this is only used in openbolt-runtime, and we don't build
  # our own curl there, we use the system version of libcurl to compile
  # native extensions against.
  pkg.build_requires 'libcurl-devel' if platform.is_rpm?
  pkg.build_requires 'libcurl4-gnutls-dev' if platform.is_deb?

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
