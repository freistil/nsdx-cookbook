COOKBOOK = "nsdx".freeze

default[COOKBOOK]["master"]["fqdn"] = node["fqdn"]
default[COOKBOOK]["master"]["ip_address"] = node["ipaddress"]
default[COOKBOOK]["master"]["contact"] = "hostmaster@example.com"
default[COOKBOOK]["slaves"] = {} # slave NS FQDN -> slave NS IP address
default[COOKBOOK]["zones"] = []

default[COOKBOOK]["packages"]["master"] = %w[
  nsd
  dnsutils
]

default[COOKBOOK]["packages"]["slave"] = %w[
  nsd
]

default[COOKBOOK]["service"]["name"] = "nsd"
default[COOKBOOK]["service"]["conf_dir"] = "/etc/nsd"

default[COOKBOOK]["service"]["user"] = "nsd"
default[COOKBOOK]["service"]["uid"] = 500
default[COOKBOOK]["service"]["group"] = "nsd"
default[COOKBOOK]["service"]["gid"] = 500

default[COOKBOOK]["databag"] = "dns"
default[COOKBOOK]["zone_contact"] = "hostmaster@example.com"
default[COOKBOOK]["default_ttl"] = 3600
