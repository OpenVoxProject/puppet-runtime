platform 'osx-15-arm64' do |plat|
  plat.inherit_from_default

  packages = %w[automake cmake pkg-config]
  plat.provision_with "/opt/homebrew/bin/brew install #{packages.join(' ')}"

  plat.output_dir File.join('apple', '15', 'PC1', 'arm64')
  plat.make 'sudo /usr/bin/make'
end
