#
# nsd_zone "example.com" do
#   action :create
# end
#

Chef::Resource.send(:include, Nsdx::Helpers)

property :zone_name, String, name_property: true
property :contact, String, default: "hostmaster@example.com"
property :ttl, Integer, default: node[COOKBOOK]["default_ttl"]

action :create do
  registry = Nsdx::ZoneRegistry.new(node)
  zone = registry.zone(new_resource.zone_name)
  zone_dir = nsd_zone_dir

  # We only have to update the real zone file
  # if the dummy file without serial number updates

  zone_template_variables = {
      zone: zone.name,
      master_fqdn: node[COOKBOOK]["master"]["fqdn"],
      master_ip_address: node[COOKBOOK]["master"]["ip_address"],
      contact: new_resource.contact.tr("@", "."),
      slaves: node[COOKBOOK]["slaves"],
      serial: Time.now.to_i,
      records: zone.records,
      ttl: new_resource.ttl,
  }
  dummy_template_variables = zone_template_variables.dup
  dummy_template_variables[:serial] = "dummy"

  template "Dummy zone file #{zone.name}" do
    path "#{zone_dir}/#{zone.name}.dummy"
    action :create
    source "nsd.zone.erb"
    cookbook COOKBOOK
    owner "root"
    group node["root_user"]
    mode 0o0644
    variables(dummy_template_variables)
    notifies :create, "template[Zone file #{zone.name}]", :immediately
  end

  template "Zone file #{zone.name}" do
    path "#{zone_dir}/#{zone.name}.zone"
    action :nothing
    source "nsd.zone.erb"
    cookbook COOKBOOK
    owner "root"
    group node["root_user"]
    mode 0o0644
    variables(zone_template_variables)
    notifies :reload, "service[nsd]"
  end
end
