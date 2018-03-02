describe file("/etc/nsd/zones/example.com.zone") do
  it { should exist }
end

describe command("host www.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) { should match "has address 1.2.3.4" }
end

# rubocop:disable Metrics/LineLength
describe command("host web.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) { should match "web.example.com is an alias for www.example.com." }
end

describe command("host -t mx example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match "example.com mail is handled by 1 aspmx.l.google.com.example.com."
  end
  its(:stdout) do
    should match "example.com mail is handled by 5 alt1.aspmx.l.google.com.example.com."
  end
  its(:stdout) do
    should match "example.com mail is handled by 5 alt2.aspmx.l.google.com.example.com."
  end
  its(:stdout) do
    should match "example.com mail is handled by 10 aspmx2.googlemail.com.example.com."
  end
  its(:stdout) do
    should match "example.com mail is handled by 10 aspmx3.googlemail.com.example.com."
  end
end
# rubocop:enable Metrics/LineLength

describe command("host -t TXT _spf.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match '_spf.example.com descriptive text "v=spf1 ~all"'
  end
end

describe command("host -t TXT example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match 'example.com descriptive text "abcdefg"'
  end
end
