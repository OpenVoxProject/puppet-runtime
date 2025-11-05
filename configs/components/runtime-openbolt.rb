# This component exists to link in the gcc runtime libraries.
component 'runtime-openbolt' do |pkg, settings, platform|
  pkg.environment "PROJECT_SHORTNAME", "bolt"

  if platform.is_windows?
    lib_type = platform.architecture == "x64" ? "seh" : "sjlj"
    pkg.install_file "#{settings[:gcc_bindir]}/libgcc_s_#{lib_type}-1.dll", "#{settings[:bindir]}/libgcc_s_#{lib_type}-1.dll"
  end
end
