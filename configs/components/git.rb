component "git" do |pkg, settings, platform|
  if platform.is_windows?
    pkg.version "2.49.0"
    pkg.md5sum "971cdee7c0feaa1e41369c46da88d1000a24e79a6f50191c820100338fb7eca5"

    release = "1"
    pkg.url "https://github.com/git-for-windows/git/releases/download/v#{pkg.get_version.split('.')[0..2].join('.')}.windows.#{release}/MinGit-#{pkg.get_version}-64-bit.zip"
    pkg.mirror "#{settings[:buildsources_url]}/MinGit-#{pkg.get_version}-64-bit.zip"
  else
    pkg.version "2.49.0"
    pkg.sha256sum "f8047f572f665bebeb637fd5f14678f31b3ca5d2ff9a18f20bd925bd48f75d3c"
    pkg.url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-#{pkg.get_version}.tar.gz"
    pkg.mirror "#{settings[:buildsources_url]}/git-#{pkg.get_version}.tar.gz"
  end

  pkg.build_requires 'curl' unless platform.is_windows?

  build_deps = []

  if platform.is_deb?
    build_deps += [
      "dh-autoreconf",
      "libexpat1-dev",
      "libz-dev",
    ]
  elsif platform.is_sles?
    build_deps += [
      "autoconf",
      "libexpat-devel",
      "zlib-devel",
    ]
  elsif platform.is_rpm?
    build_deps += [
      "dh-autoreconf",
      "expat-devel",
      "zlib-devel",
    ]
  elsif platform.is_windows?
    build_deps += [
      "7zip.commandline",
    ]
  end

  if platform.name.match(/^el\-(?:8|9)\-(?:x86_64|aarch64)/)
    build_deps.reject! { |r| r == 'dh-autoreconf' }
  end

  build_deps.each do |dep|
    pkg.build_requires dep
  end

  prefix = File.join(settings[:privatedir], 'git')
  execdir = File.join(prefix, 'lib', 'git-core')

  make_flags = [
    "-j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
    "prefix=#{prefix}",
    "gitexecdir=#{execdir}",
    "libexecdir=#{execdir}",
    "NO_INSTALL_HARDLINKS=1",
    "BLK_SHA1=1",
    "GNU_ROFF=1",
    "NO_PERL=1",
    "NO_PYTHON=1",
    "NO_TCLTK=1",
    "NO_GETTEXT=1",
    "CFLAGS=\"#{settings[:cflags]}\"",
    "LDFLAGS=\"#{settings[:ldflags]}\"",
    "CURL_CONFIG=\"#{settings[:prefix]}/bin/curl-config\"",
  ]

  if platform.is_macos?
    # This lets us build/link against vendored OpenSSL instead.
    make_flags << "NO_APPLE_COMMON_CRYPTO=1"
  end

  if settings[:git_sysconfdir]
    make_flags << "sysconfdir=#{settings[:git_sysconfdir]}"
  end

  make_argv = make_flags.join(' ')

  pkg.build do
    if platform.is_windows?
      # We are using a pre-compiled minimal archive of Git for Windows so
      # there is no build step.
      "true"
    else
      "#{platform[:make]} #{make_argv}"
    end
  end

  pkg.install do
    if platform.is_windows?
      install_cmds = [
        "mkdir -p #{prefix}",
        "cp --recursive --target-directory=#{prefix} *",
      ]
    else
      install_cmds = [ "#{platform[:make]} #{make_argv} install" ]

      # make install includes a lot of things we don't actually need in the package,
      # so we delete the stuff we don't want after install, this list is mostly based on
      # the Debian maintained package build script
      install_cmds += [
        "rm -f #{prefix}/bin/git-cvsserver",
        "rm -f #{prefix}/bin/gitk",
        "rm -f #{execdir}/git-archimport",
        "rm -f #{execdir}/git-cvs",
        "rm -f #{execdir}/git-p4",
        "rm -f #{execdir}/git-svn",
        "rm -f #{execdir}/git-send-email",
        "rm -f #{execdir}/git-gui",
        "rm -f #{execdir}/git-citool",
        "rm -Rf #{prefix}/share/git-gui",
        "rm -Rf #{prefix}/share/gitk",
        "rm -Rf #{prefix}/share/gitweb",
        "rm -Rf #{prefix}/share/locale",
        "rm -Rf #{prefix}/share/man",
        "rm -Rf #{prefix}/share/perl5/Git/SVN*",
      ]

      if platform.is_deb?
        install_cmds << "rm -Rf #{prefix}/lib/x86_64-linux-gnu"
      elsif platform.is_rpm?
        install_cmds << "rm -Rf #{prefix}/lib64"
      end
    end

    install_cmds
  end
end
