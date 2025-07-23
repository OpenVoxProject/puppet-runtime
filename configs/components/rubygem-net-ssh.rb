#####
# Component release information:
#   https://rubygems.org/gems/net-ssh
#   https://github.com/net-ssh/net-ssh/blob/master/CHANGES.txt
#####
component "rubygem-net-ssh" do |pkg, settings, platform|
  if platform.is_cross_compiled? && platform.is_solaris?
    # Building agent-runtime-7.x on Solaris 10/11 SPARC fails with newer versions of net-ssh because those platforms
    # use older (<= 2.1) versions of Ruby for cross-compiling. Pin to 4.2.0, the last version of net-ssh that supports
    # those older Rubies, until we deprecate those platforms.
    pkg.version '4.2.0'
    pkg.md5sum "fec5b151d84110b95ec0056017804491"
  else
    pkg.version '7.3.0'
    pkg.sha256sum '172076c4b30ce56fb25a03961b0c4da14e1246426401b0f89cba1a3b54bf3ef0'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
