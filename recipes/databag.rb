include_recipe "nsdx::default"

Chef::Recipe.send(:include, Nsdx::Helpers)

def process_zone_item(zone_item)
  zone_name = zone_item["domain_name"]

  add_static_records(zone_item)

  if zone_item["autopopulate"]
    add_chef_nodes(zone_name)
  end

  nsdx_zone zone_name do
    contact zone_item["contact"] || node[COOKBOOK]["zone_contact"]
  end
end

def add_static_records(zone_item)
  %w[a mx cname spf txt].each do |type|
    if zone_item.key?(type_hash_key(type))
      process_record_type(zone_item, type)
    end
  end
end

def type_hash_key(type)
  "#{type}_rr"
end

def process_record_type(zone_item, type)
  counter = 1

  zone_item[type_hash_key(type)].each do |element|
    zone = zone_item["domain_name"]
    add_record_from_item(zone, type, element)
    counter += 1
  end
end

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
def add_record_from_item(zone, type, element)
  rr_name = resource_record_name(type, element)

  nsdx_record "#{zone} #{type.upcase} #{rr_name}" do
    host rr_name
    zone zone
    type type.upcase
    ip_address element["ipv4"] unless element["ipv4"].nil?
    cname element["cname"] unless element["cname"].nil?
    preference element["distance"] unless element["distance"].nil?
    mx element["mx"] unless element["mx"].nil?
    policy element["policy"] unless element["policy"].nil?
    text element["text"] unless element["text"].nil?
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity

def resource_record_name(type, element)
  entry_name = if type == "mx"
                 element["subdomain"]
               else
                 element["host"]
               end
  entry_name = "@" if entry_name.empty?
  entry_name
end

def add_chef_nodes(zone)
  zone_nodes = search(:node, "domain:#{zone} OR domain:.#{zone}")
  zone_nodes.each do |zone_node|
    address = node_public_ip(zone_node)

    nsdx_record "A record #{zone_node['fqdn']}" do
      host zone_node["hostname"]
      zone zone
      type "A"
      ip_address address
    end
  end
end

def node_public_ip(node_obj)
  node_obj["ipaddress"]
end

#
# main
#

databag_name = node[COOKBOOK]["databag"]
begin
  items = data_bag(databag_name)
  items.each do |item_key|
    process_zone_item(data_bag_item(databag_name, item_key))
  end
rescue
  Chef::Log.error "Could not load DNS data bag '#{databag_name}'."
end
