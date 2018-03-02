#
# nsd_record "www" do
#   action :create
#   type "A"
#   ip_address "10.0.0.1"
# end
#
property :host, String
property :zone, String
property :type, String, default: "A"
property :ip_address, String
property :preference, Integer
property :mx, String
property :cname, String
property :policy, String
property :text, String

action :create do
  record = Nsdx::ResourceRecordFactory.record(
    host: new_resource.host,
    zone: new_resource.zone,
    type: new_resource.type,
    ip_address: new_resource.ip_address,
    preference: new_resource.preference,
    mx: new_resource.mx,
    cname: new_resource.cname,
    policy: new_resource.policy,
    text: new_resource.text,
  )
  registry = Nsdx::ZoneRegistry.new(node)
  zone = registry.zone(new_resource.zone)
  zone.add_record(record)
end
