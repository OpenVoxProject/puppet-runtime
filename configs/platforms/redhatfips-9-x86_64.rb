platform "redhatfips-9-x86_64" do |plat|
  plat.inherit_from_default
  plat.provision_with "dnf config-manager --set-enabled crb"
  plat.docker_image "almalinux:9"
  plat.docker_arch "linux/amd64"
end
