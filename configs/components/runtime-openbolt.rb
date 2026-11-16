# This component exists to link in the gcc runtime libraries.
component 'runtime-openbolt' do |pkg, settings, platform|
  pkg.environment 'PROJECT_SHORTNAME', 'bolt'

  if platform.is_windows?
    if settings[:cygwin]
      # Runtime dependencies of Ruby
      lib_type = platform.architecture == 'x64' ? 'seh' : 'sjlj'
      pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll",
                       "#{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll"
      pkg.install_file "#{settings[:gcc_bindir]}/libstdc++-6.dll", "#{settings[:bindir]}/libstdc++-6.dll"
      pkg.install_file "#{settings[:gcc_bindir]}/libwinpthread-1.dll", "#{settings[:bindir]}/libwinpthread-1.dll"
      pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:bindir]}/zlib1.dll"
    elsif settings[:msys]
      pkg.build_requires 'mingw-w64-ucrt-x86_64-gmp'
      pkg.build_requires 'mingw-w64-ucrt-x86_64-libwinpthread'
      pkg.build_requires 'mingw-w64-ucrt-x86_64-zlib'

      # Matches what the ruby-lang.org builds copy into ruby_builtin_dlls
      pkg.install_file "#{settings[:gcc_bindir]}/libgmp-10.dll", "#{settings[:bindir]}/libgmp-10.dll"
      pkg.install_file "#{settings[:gcc_bindir]}/libwinpthread-1.dll", "#{settings[:bindir]}/libwinpthread-1.dll"
      pkg.install_file "#{settings[:gcc_bindir]}/libz-1.dll", "#{settings[:bindir]}/libz-1.dll"
    end
  end
end
