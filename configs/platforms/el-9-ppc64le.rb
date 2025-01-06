platform 'el-9-ppc64le' do |plat|
  plat.inherit_from_default
  plat.provision_with("dnf install -y --allowerasing swig")
end
