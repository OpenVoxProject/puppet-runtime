platform 'macos-all-x86_64' do |plat|
  plat.inherit_from_default

  packages = %w[cmake pkg-config bison]
  # If we ever compile natively, remove these two lines
  plat.brew '/opt/homebrew/bin/brew'
  plat.cross_compiled true

  plat.provision_with "brew install #{packages.join(' ')}"

  plat.output_dir File.join('macos', 'all', 'x86_64')
end
