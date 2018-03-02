Chef::Recipe.send(:include, Nsdx::Helpers)

directory nsd_zone_dir do
  action :create
  owner "root"
  group node["root_group"]
  mode 0o0755
  recursive true
end
