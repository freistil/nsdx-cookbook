describe file("/etc/nsd/zones/example.com.zone") do
  it { should exist }
  its(:content) { should match(/SOA ns1\.example\.com\. info\.example\.com\./) }
  its(:content) { should match(/www\s*IN\s*A\s*1.2.3.4/) }
  its(:content) { should match(/@\s*IN\s*MX\s*10\s+mx1/) }
  its(:content) { should match(/@\s*IN\s*MX\s*20\s+mx2/) }
  its(:content) { should match(/blog\s*IN\s*CNAME\s*www/) }
end

describe command("host www.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) { should match "has address 1.2.3.4" }
end

describe command("host example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match "example.com mail is handled by 10 mx1.example.com."
  end
  its(:stdout) do
    should match "example.com mail is handled by 20 mx2.example.com."
  end
end

describe command("host blog.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match "blog.example.com is an alias for www.example.com."
  end
end

describe command("host -t TXT _spf.example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) do
    should match '_spf.example.com descriptive text "v=spf1 ~all"'
  end
end

describe command("host -t TXT example.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) { should match 'example.com descriptive text "abcdefg"' }
end

describe command("host www.notanexample.com localhost") do
  its("exit_status") { should eq 0 }
  its(:stdout) { should match "has address 3.4.5.6" }
end
