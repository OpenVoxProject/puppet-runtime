component 'rubygem-openfact' do |pkg, settings, platform|
  pkg.version '5.0.0'
  pkg.md5sum '90a0f4a39606f3837298308cbfa19a09'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
