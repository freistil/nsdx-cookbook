name "nsdx_test"
maintainer "freistil IT Ltd"
maintainer_email "ops@freistil.it"
license "MIT"
version "0.1.0"
description "Test cookbook for nsdx"

recipe "nsdx_test::default", "Set up an example DNS zone for testing"

supports "ubuntu"

depends "nsdx"
