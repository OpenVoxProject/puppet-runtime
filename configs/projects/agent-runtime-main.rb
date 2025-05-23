project 'agent-runtime-main' do |proj|

  # Set preferred component versions if they differ from defaults:
  proj.setting :ruby_version, '3.2.8'
  proj.setting :rubygem_deep_merge_version, '1.2.2'
  proj.setting :rubygem_highline_version, '3.0.1'
  proj.setting :rubygem_hocon_version, '1.4.0'
  proj.setting :rubygem_net_ssh_version, '7.2.3'

  # Solaris and AIX depend on libedit which breaks augeas compliation starting with 1.13.0
  if platform.is_solaris? || platform.name == 'aix-7.1-ppc'
    proj.setting :augeas_version, '1.12.0'
  else
    proj.setting :augeas_version, '1.14.1'
  end

  ########
  # Load shared agent settings
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-settings.rb'))

  ########
  # Settings specific to this branch
  ########

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  # Ruby 2.7 loads openssl on installation. Because pl-ruby was not
  # built with openssl support, we switch to compile with system
  # rubies.
  # Solaris 11 seems to work with pl-ruby, and 10 is handled in _shared-agent-settings.rb.
  if platform.is_cross_compiled_linux?
    proj.setting(:host_ruby, "/usr/bin/ruby")
  end

  # Ruby 2.6 (RubyGems 3.0.1) removed the --ri and --rdoc
  # options. Switch to using --no-document which is available starting
  # with RubyGems 2.0.0preview2. This should also cover cross-compiled
  # platforms that use older rubies.
  proj.setting(:gem_install, "#{proj.host_gem} install --no-document --local")

  ########
  # Load shared agent components
  ########

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-agent-components.rb'))

  ########
  # Components specific to the main branch
  ########

  # When adding components to this list, please
  # add them to pe-installer-runtime-main as well
  proj.component 'rubygem-concurrent-ruby'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-optimist'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-hiera-eyaml'
  proj.component 'rubygem-thor'
  proj.component 'rubygem-scanf'

  if platform.is_linux?
    proj.component "virt-what"
    proj.component "dmidecode" unless platform.architecture =~ /ppc64/
  end

  unless platform.is_windows?
    proj.component 'rubygem-sys-filesystem'
  end

  # Nokogiri and dependencies to improve macOS performance (PUP-11332)
  if platform.is_macos?
    proj.component 'rubygem-nokogiri'
    proj.component 'rubygem-mini_portile2'
  end

  # Dependencies for gettext for Ruby >= 3.2 (PA-4815)
  proj.component 'rubygem-erubi'
  proj.component 'rubygem-prime'

  # We are currently not building pxp-agent for Windows because it is unused for
  # OpenVox aside from execution_wrapper which is soon to be replaced, and because
  # we're having trouble getting things compiled correctly with the modern toolchain.
  # For a Windows, only build these if BUILD_WINDOWS_PXP_AGENT is set.
  # For other platforms, build these unless NO_PXP_AGENT is set.
  build_for_pxp_agent = platform.is_windows? ? !ENV['BUILD_WINDOWS_PXP_AGENT'].to_s.empty? : ENV['NO_PXP_AGENT'].to_s.empty?
  proj.component 'boost' if build_for_pxp_agent
end
