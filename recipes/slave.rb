instance = ::ChefCookbook::Instance::Helper.new(node)
secret = ::ChefCookbook::Secret::Helper.new(node)

include_recipe "#{COOKBOOK}::service_user"

node[COOKBOOK]["packages"]["slave"].each do |pkg_name|
  package pkg_name do
    action :install
  end
end

service_name = node[COOKBOOK]["service"]["name"]
service_resource = "service[#{service_name}]"

service service_name do
  action %i[start enable]
end

zone_dir = ::File.join(node[COOKBOOK]["service"]["conf_dir"], "zones")

directory zone_dir do
  owner "root"
  group node["root_group"]
  mode 0o0755
  action :create
end

service_user = node[COOKBOOK]["service"]["user"]

template service_conf_file do
  source "nsd.slave.conf.erb"
  owner "root"
  group node["root_group"]
  variables(
    service_user: service_user,
    zone_dir: zone_dir,
    log_file: "/var/log/nsd.log",
    pid_file: "/run/nsd/nsd.pid",
    key_name: instance.fqdn,
    key_secret: secret.get("nsd:keys:#{instance.fqdn}", prefix_fqdn: false),
    zones: node[COOKBOOK]["zones"],
    master_ip_address: node[COOKBOOK]["master"]["ip_address"],
  )
  mode 0o0644
  action :create
  notifies :restart, service_resource, :delayed
end
