require "date"

include_recipe "#{COOKBOOK}::service_user"
Chef::Recipe.send(:include, Nsdx::Helpers)

secret = ::ChefCookbook::Secret::Helper.new(node)

node[COOKBOOK]["packages"]["master"].each do |pkg_name|
  package pkg_name do
    action :install
  end
end

service_name = node[COOKBOOK]["service"]["name"]
service_resource = "service[#{service_name}]"

service service_name do
  action %i[start enable]
end

service_user = node[COOKBOOK]["service"]["user"]

registry = Nsdx::ZoneRegistry.new(node)
zone_dir = nsd_zone_dir

template service_conf_file do
  source "nsd.master.conf.erb"
  owner "root"
  group node["root_group"]
  variables(
    service_user: service_user,
    zone_dir: zone_dir,
    log_file: "/var/log/nsd.log",
    pid_file: "/run/nsd/nsd.pid",
    keys: secret.get("nsd:keys", default: {}, prefix_fqdn: false),
    slaves: node[COOKBOOK]["slaves"],
    zones: lazy { registry.zones },
  )
  mode 0x0644
  action :create
  notifies :restart, service_resource, :delayed
end

for_all_zones do |zone|
end
