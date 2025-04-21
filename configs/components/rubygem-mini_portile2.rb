component 'rubygem-mini_portile2' do |pkg, _settings, _platform|
  pkg.version '2.8.8'
  pkg.sha256sum '8e47136cdac04ce81750bb6c09733b37895bf06962554e4b4056d78168d70a75'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment 'GEM_HOME', settings[:gem_home]
end
