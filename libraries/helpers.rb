COOKBOOK = "nsdx".freeze

module Nsdx
  module Helpers
    def self.nsd_zone_dir(node)
      ::File.join(
        node[COOKBOOK]["service"]["conf_dir"],
        "zones",
      )
    end

    def self.service_conf_file(node)
      ::File.join(
        node[COOKBOOK]["service"]["conf_dir"],
        "nsd.conf",
      )
    end
  end
end

class Chef
  class Recipe
    def for_all_zones
      puts "for_all_zones\n"
      return unless node.run_state.key?(COOKBOOK)
      node.run_state[COOKBOOK].each_pair do |_name, zone|
        yield(zone)
      end
    end
  end
end
