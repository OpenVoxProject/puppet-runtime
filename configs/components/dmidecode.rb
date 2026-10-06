#####
# Component release information: https://github.com/mirror/dmidecode/tags (out of date)
#                                http://www.nongnu.org/dmidecode/
# Note: We should pull the tarball from https://ftp.debian.org/debian/pool/main/d/dmidecode
#       because savannah.gnu.org goes down frequently.
#####
component 'dmidecode' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/dmidecode.json')
  # The tarball name from the Debian mirror does not match the directory it unpacks to
  pkg.dirname "dmidecode-#{pkg.get_version}"

  pkg.apply_patch 'resources/patches/dmidecode/dmidecode-install-to-bin.patch'

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} prefix=#{settings[:prefix]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -f #{settings[:bindir]}/vpddecode #{settings[:bindir]}/biosdecode #{settings[:bindir]}/ownership",
      "rm -f #{settings[:mandir]}/man8/ownership.8 #{settings[:mandir]}/man8/biosdecode.8 #{settings[:mandir]}/man8/vpddecode.8"
    ]
  end
end
