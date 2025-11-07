#####
# Component release information:
#   http://git.annexia.org/?p=virt-what.git;a=summary
#   https://people.redhat.com/~rjones/virt-what/files/
# Notes:
#   One of the first search results for this is
#   https://github.com/chuckleb/virt-what, which you
#   SHOULD NOT USE as this is a fork.
#####
component "virt-what" do |pkg, settings, platform|
  pkg.version '1.27'
  pkg.sha256sum 'd4d9bd9d4ae59095597443fac663495315c7eb4330b872aa5f062df38ac69bf1'

  # 2025-08-05: The upstream site was down, so using a mirror here. Revert this back to the
  # original URL next time we bump this.
  #pkg.url "https://people.redhat.com/~rjones/virt-what/files/virt-what-#{pkg.get_version}.tar.gz"
  pkg.url "https://artifacts.voxpupuli.org/components/virt-what-#{pkg.get_version}.tar.gz"

  pkg.replaces 'pe-virt-what'

  # Run-time requirements
  unless platform.is_deb?
    requires "util-linux"
  end

  if platform.is_rpm?
    pkg.build_requires "util-linux"
  end

  if platform.is_linux?
    if platform.architecture =~ /ppc64le$/
      host_opt = '--host powerpc64le-unknown-linux-gnu'
    elsif platform.architecture =~ /ppc64$/
      host_opt = '--host powerpc64-unknown-linux-gnu'
    end
  end

  if platform.is_cross_compiled_linux?
    host_opt = "--host #{platform.platform_triple}"

    pkg.environment "PATH" => "$$PATH:#{settings[:bindir]}"
    pkg.environment "CFLAGS" => settings[:cflags]
    pkg.environment "LDFLAGS" => settings[:ldflags]
  end

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --sbindir=#{settings[:prefix]}/bin --libexecdir=#{settings[:prefix]}/lib/virt-what #{host_opt}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
