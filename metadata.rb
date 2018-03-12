name "nsdx"
maintainer "freistil IT Ltd"
maintainer_email "ops@freistil.it"
license "MIT"
version "1.0.0"
description "Install and configure NSD"

if respond_to?(:source_url)
  source_url "https://github.com/freistil/nsdx-cookbook"
end
if respond_to?(:issues_url)
  issues_url "https://github.com/freistil/nsdx-cookbook/issues"
end

chef_version ">= 12"

supports "ubuntu"

depends "instance", "~> 2.0.0"
depends "secret", "~> 1.0.0"

recipe "nsdx::master", "Install an NSD master server"

