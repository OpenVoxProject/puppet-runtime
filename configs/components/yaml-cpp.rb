component "yaml-cpp" do |pkg, settings, platform|
  pkg.url "https://github.com/jbeder/yaml-cpp.git"
  pkg.ref "refs/tags/0.8.0"

  # Build-time Configuration
  cmake_toolchain_file = ''
  make = 'make'
  mkdir = 'mkdir'
  prefix = settings[:prefix]
  cmake = if platform.name =~ /amazon-2-aarch64/
    '/usr/bin/cmake3'
  else
    'cmake'
  end

  if platform.is_cross_compiled_linux?
    # We're using the x86_64 version of cmake
    cmake = "/opt/pl-build-tools/bin/cmake"
    cmake_toolchain_file = "-DPL_TOOLS_ROOT=/opt/freeware -DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/#{settings[:platform_triple]}/pl-build-toolchain.cmake"
  elsif platform.is_solaris?
    if platform.os_version != '10'
      make = '/usr/bin/gmake'
    end

    if !platform.is_cross_compiled? && platform.architecture == 'sparc'
      pkg.environment "PATH", "$(PATH):/opt/pl-build-tools/bin"
    else
      # We always use the i386 build of cmake, even when cross-compiling on sparc
      cmake = "/opt/pl-build-tools/i386-pc-solaris2.#{platform.os_version}/bin/cmake"
      cmake_toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/#{settings[:platform_triple]}/pl-build-toolchain.cmake"
      pkg.environment "PATH", "$(PATH):/opt/csw/bin"
    end
  elsif platform.is_macos?
    cmake_toolchain_file = ""
    cmake = "/usr/local/bin/cmake"
    if platform.is_cross_compiled?
      pkg.environment 'CXX', 'clang++ -target arm64-apple-macos11' if platform.name =~ /osx-11/
      pkg.environment 'CXX', 'clang++ -target arm64-apple-macos12' if platform.name =~ /osx-12/
    elsif platform.architecture == 'arm64' && platform.os_version.to_i >= 13
      pkg.environment 'CXX', 'clang++'
      cmake = "/opt/homebrew/bin/cmake"
    end
    extraflags = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

  elsif platform.is_windows?
    mkdir = '/usr/bin/mkdir'
    pkg.environment "PATH", "/usr/bin:$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:ruby_bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
    pkg.environment "CYGWIN", settings[:cygwin]
    cmake = "/usr/bin/cmake"
    cmake_toolchain_file = ''
    prefix = "$(shell cygpath -u #{settings[:prefix]})"
    extraflags = "-DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++"
    pkg.environment 'CC', "x86_64-w64-mingw32-gcc"
    pkg.environment 'CXX', "x86_64-w64-mingw32-g++"
  elsif platform.name =~ /aix-7\.1-ppc|el-[56]|redhatfips-7|sles-(?:11)/
    cmake = "#{settings[:tools_root]}/bin/cmake"
    cmake_toolchain_file = "-DCMAKE_TOOLCHAIN_FILE=#{settings[:tools_root]}/pl-build-toolchain.cmake"
  else
    if platform.is_aix?
      pkg.environment "PATH", "$(PATH):/opt/freeware/bin"
      cmake = "/opt/freeware/bin/cmake"
    end
    pkg.environment 'CPPFLAGS', settings[:cppflags]
    pkg.environment 'CFLAGS', settings[:cflags]
    pkg.environment 'LDFLAGS', settings[:ldflags]
  end

  extraflags = "-DCMAKE_CXX_COMPILER='/opt/rh/devtoolset-7/root/usr/bin/g++'" if platform.name =~ /el-7/

  # Build Commands
  pkg.build do
    [ "#{mkdir} build",
      "cd build",
      "#{cmake} \
      #{cmake_toolchain_file} \
      -DCMAKE_INSTALL_PREFIX=#{prefix} \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DYAML_CPP_BUILD_TOOLS=0 \
      -DYAML_CPP_BUILD_TESTS=0 \
      -DBUILD_SHARED_LIBS=ON \
      #{extraflags} \
      .. ",
      "#{make} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
    ]
  end

  pkg.install do
    [ "cd build",
      "#{make} install",
    ]
  end
end
