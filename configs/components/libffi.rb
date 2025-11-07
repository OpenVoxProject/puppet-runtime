#####
# Component release information: https://github.com/libffi/libffi/releases
#####
component 'libffi' do |pkg, settings, platform|
  pkg.version '3.5.2'
  pkg.sha256sum 'f3a3082a23b37c293a4fcd1053147b371f2ff91fa7ea1b2a52e335676bac82dc'
  pkg.url "https://github.com/libffi/libffi/releases/download/v#{pkg.get_version}/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  if platform.is_aix?
    pkg.environment 'PATH', '/opt/freeware/bin:$(PATH)'
  elsif platform.is_cross_compiled_linux?
    pkg.environment 'PATH', "$(PATH):#{settings[:bindir]}"
  elsif platform.is_solaris?
    pkg.environment 'PATH', "$(PATH):/usr/local/bin:/usr/ccs/bin:/usr/sfw/bin:#{settings[:bindir]}"
    if !platform.is_cross_compiled? && platform.architecture == 'sparc'
      # must use gnu99 due to `asm` keyword
      # https://gcc.gnu.org/onlinedocs/gcc-7.2.0/gcc/Extended-Asm.html
      pkg.environment 'CFLAGS', "#{settings[:cflags]} -std=gnu99"
    else
      pkg.environment 'CFLAGS', "#{settings[:cflags]} -std=c99"
    end
    pkg.environment 'MAKE', 'gmake'
  elsif platform.is_macos?
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  elsif platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
  else

  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --sbindir=#{settings[:prefix]}/bin --libexecdir=#{settings[:prefix]}/lib/libffi --disable-multi-os-directory #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end
end
