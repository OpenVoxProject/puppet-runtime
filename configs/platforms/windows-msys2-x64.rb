platform 'windows-msys2-x64' do |plat|
  plat.vmpooler_template 'win-2022-x86_64'

  plat.servicetype 'windows'

  # MSYS2 must be pre-installed at C:/msys64 on the build image.
  # Install required UCRT64 toolchain and library packages via pacman.
  packages = [
    'autoconf',
    'git',
    'make',
    'mingw-w64-ucrt-x86_64-gcc',
    'mingw-w64-ucrt-x86_64-gdbm',
    'mingw-w64-ucrt-x86_64-libffi',
    'mingw-w64-ucrt-x86_64-libyaml',
    'mingw-w64-ucrt-x86_64-readline',
    'mingw-w64-ucrt-x86_64-ruby',
    'mingw-w64-ucrt-x86_64-zlib',
    'mingw-w64-ucrt-x86_64-gcc-libs',
    'patch',
  ]

  plat.provision_with("C:/msys64/usr/bin/pacman.exe -S --noconfirm --needed #{packages.join(' ')}")
  plat.install_build_dependencies_with 'C:/msys64/usr/bin/pacman.exe -S --noconfirm --needed'

  plat.make '/usr/bin/make'
  plat.patch 'TMP=/var/tmp /usr/bin/patch.exe --binary'

  plat.platform_triple 'x86_64-w64-mingw32'

  # In the MSYS2 UCRT64 environment, gcc is the native UCRT64 compiler.
  # Do not use the full x86_64-w64-mingw32- prefix here; that is only needed
  # when cross-compiling from a Cygwin host.
  plat.environment 'CC', 'gcc'
  plat.environment 'CXX', 'g++'

  plat.package_type 'archive'
  plat.output_dir 'windows'
end
