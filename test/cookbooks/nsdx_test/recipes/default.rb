include_recipe "nsdx::default"

nsdx_record "www.example.com" do
  host "www"
  zone "example.com"
  type "A"
  ip_address "1.2.3.4"
end

nsdx_record "example.com MX" do
  host "@"
  zone "example.com"
  type "MX"
  mx "mx1"
  preference 10
end

nsdx_record "example.com MX 2" do
  host "@"
  zone "example.com"
  type "MX"
  mx "mx2"
  preference 20
end

nsdx_record "blog.example.com" do
  host "blog"
  zone "example.com"
  type "CNAME"
  cname "www"
end

nsdx_record "_spf.example.com" do
  host "_spf"
  zone "example.com"
  type "SPF"
  policy "v=spf1 ~all"
end

nsdx_record "example.com" do
  host "@"
  zone "example.com"
  type "TXT"
  text "abcdefg"
end

nsdx_zone "example.com" do
  contact "info@example.com"
end

nsdx_record "www.notanexample.com" do
  host "www"
  zone "notanexample.com"
  type "A"
  ip_address "3.4.5.6"
end

nsdx_zone "notanexample.com" do
  contact "info@notanexample.com"
end
