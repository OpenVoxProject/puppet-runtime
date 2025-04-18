component 'rubygem-erubi' do |pkg, settings, platform|
  pkg.version '1.13.1'
  pkg.sha256sum 'a082103b0885dbc5ecf1172fede897f9ebdb745a4b97a5e8dc63953db1ee4ad9'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
