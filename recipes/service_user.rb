service_user = node[COOKBOOK]["service"]["user"]
service_uid = node[COOKBOOK]["service"]["uid"]
service_group = node[COOKBOOK]["service"]["group"]
service_gid = node[COOKBOOK]["service"]["gid"]

group service_group do
  gid service_gid
  action :create
end

user service_user do
  uid service_uid
  group service_group
  shell "/bin/false"
  system true
  action :create
end
