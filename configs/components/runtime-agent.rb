# This component exists to link in the gcc and stdc++ runtime libraries as well as libssp.
component 'runtime-agent' do |pkg, settings, platform|
  pkg.environment 'PROJECT_SHORTNAME', 'puppet'
  pkg.add_source 'file://resources/files/runtime/runtime.sh'

  if platform.is_windows?
    lib_type = platform.architecture == 'x64' ? 'seh' : 'sjlj'
    pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll",
                     "#{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libstdc++-6.dll", "#{settings[:bindir]}/libstdc++-6.dll"
    pkg.install_file "#{settings[:gcc_bindir]}/libwinpthread-1.dll", "#{settings[:bindir]}/libwinpthread-1.dll"

    # Curl is dynamically linking against zlib, so we need to include this file until we
    # update curl to statically link against zlib
    pkg.install_file "#{settings[:tools_root]}/bin/zlib1.dll", "#{settings[:ruby_bindir]}/zlib1.dll"

    # gdbm and iconv are all runtime dependencies of ruby, and their libraries need
    # to exist inside our vendored ruby
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm-6.dll", "#{settings[:ruby_bindir]}/libgdbm-6.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libgdbm_compat-4.dll",
                     "#{settings[:ruby_bindir]}/libgdbm_compat-4.dll"
    #pkg.install_file "#{settings[:tools_root]}/bin/libffi-6.dll", "#{settings[:ruby_bindir]}/libffi-6.dll"
    pkg.install_file "#{settings[:tools_root]}/bin/libffi-8.dll", "#{settings[:ruby_bindir]}/libffi-8.dll"
  end
end
