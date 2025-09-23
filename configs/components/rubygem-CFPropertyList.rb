#####
# Component release information:
#   https://rubygems.org/gems/CFPropertyList
#   https://github.com/ckruse/CFPropertyList/tags
#####
component 'rubygem-CFPropertyList' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '3.0.7'
    pkg.md5sum 'ed89ce5e7074a6f8e8b8e744eaf014d0'
    pkg.build_requires 'base64'
  else
    pkg.version '2.3.6'
    pkg.md5sum 'ae4086185992f293ffab1641b83286a5'
  end

  pkg.build_requires 'rubygem-rexml'
  # Also requires nkf, part of the Ruby standard library (ext) as of 3.2

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment "GEM_HOME", settings[:gem_home]
end
