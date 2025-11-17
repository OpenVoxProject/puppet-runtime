project 'openbolt-runtime' do |proj|
  proj.description 'The OpenBolt runtime contains third-party components needed for OpenBolt standalone packaging'
  proj.license 'See components'
  proj.vendor 'Vox Pupuli <openvox@voxpupuli.org>'
  proj.homepage 'https://github.com/OpenVoxProject'
  proj.version_from_git
  proj.identifier platform.is_macos? ? 'org.voxpupuli' : 'voxpupuli.org'

  # Export the settings for the current project and platform as yaml during builds
  proj.publish_yaml_settings

  # Generate a tarball, not a package
  proj.generate_archives true
  proj.generate_packages false

  # Windows builds can be really slow
  proj.timeout 7200 if platform.is_windows?

  platform = proj.get_platform

  ########
  # Project Settings
  ########
  proj.setting :ruby_version, '3.2' # Leave the .Z out for Ruby 3.2
  ruby_base_version = proj.ruby_version.gsub(/(\d+)\.(\d+)(\.\d+)?/, '\1.\2.0')

  # Legacy algos must be enabled in OpenSSL >= 3.0 for OpenBolt's WinRM transport to work.
  proj.setting :use_legacy_openssl_algos, true
  proj.setting :openssl_version, '3.0'

  # Used in component configurations to conditionally include dependencies
  proj.setting :runtime_project, 'openbolt'

  # Windows-specific settings
  proj.setting :company_id, 'VoxPupuli'
  proj.setting :pl_company_id, 'PuppetLabs'
  proj.setting :product_id, 'OpenBolt'
  proj.setting :pl_product_id, 'Bolt'
  proj.setting :base_dir, 'ProgramFiles64Folder'
  # We build for windows not in the final destination, but in the paths that correspond
  # to the directory ids expected by WIX. This will allow for a portable installation (ideally).
  windows_prefix = File.join('C:', proj.base_dir, proj.pl_company_id, proj.pl_product_id)

  # Install paths
  proj.setting :prefix, platform.is_windows? ? windows_prefix : '/opt/puppetlabs/bolt'
  proj.setting :bindir, File.join(proj.prefix, 'bin')
  proj.setting :libdir, File.join(proj.prefix, 'lib')
  proj.setting :includedir, File.join(proj.prefix, 'include')
  proj.setting :datadir, File.join(proj.prefix, 'share')
  proj.setting :mandir, File.join(proj.datadir, 'man')

  # Ruby paths
  proj.setting :ruby_dir, proj.prefix
  proj.setting :ruby_bindir, proj.bindir
  ruby_bin = platform.is_windows? ? 'ruby.exe' : 'ruby'
  gem_bin = platform.is_windows? ? 'gem.bat' : 'gem'
  proj.setting :host_ruby, File.join(proj.ruby_bindir, ruby_bin)
  proj.setting :host_gem, File.join(proj.ruby_bindir, gem_bin)
  proj.setting :gem_home, File.join(proj.libdir, 'ruby', 'gems', ruby_base_version)
  proj.setting :gem_install, "#{proj.host_gem} install --no-document --local --bindir=#{proj.ruby_bindir}"

  proj.setting :host, platform.is_windows? ? "--host #{platform.platform_triple}" : nil

  # For Windows, we need to specify where tools are located within the Cygwin environment
  if platform.is_windows?
    proj.setting :tools_root, '/usr/x86_64-w64-mingw32/sys-root/mingw' if platform.is_windows?
    proj.setting :gcc_bindir, "#{proj.tools_root}/bin"
    proj.setting :cygwin, 'nodosfilewarning winsymlinks:native'
  end

  # We now target MacOS 13 as the minimum version, and build a binary
  # that works for all MacOS versions since then, rather than building
  # separate ones for each version.
  if platform.is_macos?
    proj.setting :deployment_target, '13.0'
    targeting_flags = "-target #{platform.architecture}-apple-darwin22 -arch #{platform.architecture} -mmacos-version-min=13.0"
    proj.setting :cc, 'clang'
    proj.setting :cxx, 'clang++'
  end

  # Compiler flag defaults
  # The flags besides -I and -L here are taken from the agent runtime.
  # Remove them if they end up causing problems for OpenBolt.
  cppflags = "-I#{proj.includedir} -D_FORTIFY_SOURCE=2"
  cflags = "#{cppflags} -fstack-protector-strong -fno-plt -O2"
  ldflags = "-L#{proj.libdir}"
  proj.setting :cppflags, case
    when platform.is_windows? then "-I#{proj.tools_root}/include -I#{proj.tools_root}/include/readline -I#{proj.includedir}"
    when platform.is_macos? then "#{targeting_flags} #{cppflags}"
    else cppflags
  end
  proj.setting :cflags, case
    when platform.is_windows? then "-I#{proj.tools_root}/include -I#{proj.tools_root}/include/readline -I#{proj.includedir}"
    when platform.is_macos? then "#{targeting_flags} #{cflags}"
    else cflags
  end
  proj.setting :ldflags, case
    when platform.is_windows? then "#{ldflags} -L#{proj.tools_root}/lib -Wl,--nxcompat -Wl,--dynamicbase"
    when platform.is_macos? then ldflags
    when platform.is_linux? then "#{ldflags} -Wl,-rpath=#{proj.libdir} -Wl,-z,relro -Wl,-z,now -pie"
    else "#{ldflags} -Wl,-rpath=#{proj.libdir}"
  end

  ########
  # Directories
  ########
  proj.directory proj.prefix

  ########
  # Components
  ########
  proj.component 'runtime-openbolt'
  proj.component 'libffi'
  proj.component 'libyaml'
  proj.component "openssl-#{proj.openssl_version}"
  proj.component 'puppet-ca-bundle'
  proj.component "ruby-#{proj.ruby_version}"

  proj.component 'rubygem-bcrypt_pbkdf'
  proj.component 'rubygem-ed25519'
  proj.component 'rubygem-logger'
  proj.component 'rubygem-base64'
  proj.component 'rubygem-hocon'
  proj.component 'rubygem-deep_merge'
  proj.component 'rubygem-text'
  proj.component 'rubygem-locale'
  proj.component 'rubygem-gettext'
  proj.component 'rubygem-prime'
  proj.component 'rubygem-fast_gettext'
  proj.component 'rubygem-scanf'
  proj.component 'rubygem-semantic_puppet'
  proj.component 'rubygem-gettext-setup'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-faraday'
  proj.component 'rubygem-faraday-em_http'
  proj.component 'rubygem-faraday-em_synchrony'
  proj.component 'rubygem-faraday-excon'
  proj.component 'rubygem-faraday-httpclient'
  proj.component 'rubygem-faraday-multipart'
  proj.component 'rubygem-faraday-net_http'
  proj.component 'rubygem-faraday-net_http_persistent'
  proj.component 'rubygem-faraday-patron'
  proj.component 'rubygem-faraday-rack'
  proj.component 'rubygem-faraday-retry'
  proj.component 'rubygem-faraday-follow_redirects'
  proj.component 'rubygem-ruby2_keywords'
  proj.component 'rubygem-addressable'
  proj.component 'rubygem-aws-eventstream'
  proj.component 'rubygem-aws-partitions'
  proj.component 'rubygem-aws-sdk-core'
  proj.component 'rubygem-aws-sdk-ec2'
  proj.component 'rubygem-aws-sigv4'
  proj.component 'rubygem-bindata'
  proj.component 'rubygem-builder'
  proj.component 'rubygem-CFPropertyList'
  proj.component 'rubygem-colored2'
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-connection_pool'
  proj.component 'rubygem-cri'
  proj.component 'rubygem-erubi'
  proj.component 'rubygem-openfact'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-gssapi'
  proj.component 'rubygem-gyoku'
  proj.component 'rubygem-hiera'
  proj.component 'rubygem-httpclient'
  proj.component 'rubygem-jmespath'
  proj.component 'rubygem-jwt'
  proj.component 'rubygem-little-plugger'
  proj.component 'rubygem-log4r'
  proj.component 'rubygem-logging'
  proj.component 'rubygem-minitar'
  proj.component 'rubygem-molinillo'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-multipart-post'
  proj.component 'rubygem-net-http-persistent'
  proj.component 'rubygem-net-scp'
  proj.component 'rubygem-net-ssh'
  proj.component 'rubygem-net-ssh-krb'
  proj.component 'rubygem-nori'
  proj.component 'rubygem-orchestrator_client'
  proj.component 'rubygem-paint'
  proj.component 'rubygem-public_suffix'
  proj.component 'rubygem-puppet'
  proj.component 'rubygem-puppet_forge'
  proj.component 'rubygem-puppet-resource_api'
  proj.component 'rubygem-puppet-strings'
  proj.component 'rubygem-puppetfile-resolver'
  proj.component 'rubygem-r10k'
  proj.component 'rubygem-rgen'
  proj.component 'rubygem-rubyntlm'
  proj.component 'rubygem-ruby_smb'
  proj.component 'rubygem-rubyzip'
  proj.component 'rubygem-sys-filesystem'
  proj.component 'rubygem-terminal-table'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-unicode-display_width'
  proj.component 'rubygem-webrick'
  proj.component 'rubygem-yard'
  proj.component 'rubygem-windows_error'
  proj.component 'rubygem-winrm'
  proj.component 'rubygem-winrm-fs'

  # Platform-specific differences
  # Components from puppet-runtime included to support apply on localhost
  # We only build ruby-selinux for EL, Fedora, Debian and Ubuntu (amd64/i386)
  proj.component 'ruby-selinux' if platform.is_el? || platform.is_fedora? || platform.is_debian? || platform.is_ubuntu?

  unless platform.is_windows?
    proj.component 'readline' if platform.is_macos?
    proj.component 'augeas'
    proj.component 'libxml2'
    proj.component 'libxslt'
    proj.component 'ruby-augeas'
    proj.component 'ruby-shadow'
  end
end
