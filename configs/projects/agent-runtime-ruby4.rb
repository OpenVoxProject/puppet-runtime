project 'agent-runtime-main' do |proj|
  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '4.0' # Leave the .Z out for Ruby 3.2
  proj.setting :rubygem_highline_version, '3.1.2'

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to this branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, 'ruby', 'vendor_gems'))

  # Ruby 2.7 loads openssl on installation. Because pl-ruby was not
  # built with openssl support, we switch to compile with system
  # rubies.
  # Solaris 11 seems to work with pl-ruby, and 10 is handled in _shared-agent-settings.rb.
  proj.setting(:host_ruby, '/usr/bin/ruby') if platform.is_cross_compiled_linux?

  # Ruby 2.6 (RubyGems 3.0.1) removed the --ri and --rdoc
  # options. Switch to using --no-document which is available starting
  # with RubyGems 2.0.0preview2. This should also cover cross-compiled
  # platforms that use older rubies.
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local")

  ########
  # Components
  # Use full blocks here, rather than single line logic so that
  # automation can insert components as needed.
  ########

  # rubocop:disable Style/IfUnlessModifier
  proj.component 'runtime-agent'
  proj.component 'libffi'
  proj.component 'libyaml'
  proj.component "openssl-#{proj.openssl_version}"

  proj.component 'puppet-ca-bundle'
  proj.component "ruby-#{proj.ruby_version}"

  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-deep_merge'
  proj.component 'rubygem-erubi'
  proj.component 'rubygem-fast_gettext'
  proj.component 'rubygem-ffi'
  proj.component 'rubygem-gettext'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hocon'
  proj.component 'rubygem-locale'
  proj.component 'rubygem-net-ssh'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-semantic_puppet'
  proj.component 'rubygem-scanf'
  proj.component 'rubygem-text'
  proj.component 'rubygem-thor'

  # We add rexml explicitly in here because even though ruby 3 ships with rexml as its default gem, the version
  # of rexml it ships with can contain CVEs. So, we add it here to update to a higher version free from the CVEs.
  proj.component 'rubygem-rexml'

  unless platform.is_windows?
    proj.component 'augeas'
    proj.component 'ruby-augeas'
    proj.component 'libxml2'
    proj.component 'rubygem-sys-filesystem'
  end

  if platform.is_macos?
    proj.component 'readline'
    proj.component 'rubygem-CFPropertyList'
    proj.component 'rubygem-base64'
  end

  unless platform.is_aix? || platform.is_windows?
    proj.component 'ruby-shadow'
  end

  # We only build ruby-selinux for EL, Fedora, Debian and Ubuntu (amd64/i386)
  if platform.is_el? || platform.is_fedora? || platform.is_debian? || (platform.is_ubuntu? && platform.architecture !~ /ppc64el$/)
    proj.component 'ruby-selinux'
  end

  # libedit is used instead of readline on these platforms
  if platform.is_solaris?
    proj.component 'libedit'
  end

  if platform.is_cross_compiled?
    proj.component 'pl-ruby-patch'
  end

  if platform.is_windows? || platform.is_solaris? || platform.is_aix?
    proj.component 'rubygem-minitar'
  end

  if platform.is_linux?
    proj.component 'virt-what'
    proj.component 'dmidecode' unless platform.architecture =~ /ppc64/
    # DBus exists outside of Linux, but it's the most common platform to find it on
    proj.component 'rubygem-ruby-dbus'
  end
  # rubocop:enable Style/IfUnlessModifier
end
