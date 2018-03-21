directory Nsdx::Helpers.nsd_zone_dir(node) do
  action :create
  owner "root"
  group node["root_group"]
  mode 0o0755
  recursive true
end
