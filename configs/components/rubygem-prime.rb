component 'rubygem-prime' do |pkg, settings, platform|
  pkg.version '0.1.3'
  pkg.sha256sum 'baf031c50d6ce923594913befc8ac86a3251bffb9d6a5e8b03687962054e53e3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
