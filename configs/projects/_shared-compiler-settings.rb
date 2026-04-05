# Define default CFLAGS and LDFLAGS for most platforms, and then
# tweak or adjust them as needed.
proj.setting(:cppflags, "-I#{proj.includedir}")
proj.setting(:cflags, proj.cppflags)
proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

# Platform specific overrides or settings, which may override the defaults

# Newer Xcode (16+) defaults clang to -std=gnu23 and C23 changes semantics in ways that
# can turn previously valid C into undefined behavior, which can cause segfaults.
proj.setting(:cflags, "#{proj.cflags} -std=gnu17") if platform.is_macos?

# Harden Linux ELF binaries by compiling with PIE (Position Independent Executables) support,
# stack canary and full RELRO.
# We only do this on platforms that use their default OS toolchain since pl-gcc versions
# are too old to support these flags.

if (platform.is_sles? && platform.os_version.to_i >= 15) ||
   (platform.is_el? && platform.os_version.to_i == 8 && platform.architecture !~ /ppc64/) ||
   (platform.is_debian? && platform.os_version.to_i >= 10) ||
   (platform.is_ubuntu? && platform.os_version.to_i >= 22) ||
   platform.is_fedora?
  proj.setting(:supports_pie, true)
  proj.setting(:cppflags, "-I#{proj.includedir} -D_FORTIFY_SOURCE=2")
  proj.setting(:cflags, '-fstack-protector-strong -fno-plt -O2')
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir},-z,relro,-z,now")
end
