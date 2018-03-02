COOKBOOK = "nsdx".freeze

module Nsdx
  module Helpers
    def nsd_zone_dir
      ::File.join(
        node[COOKBOOK]["service"]["conf_dir"],
        "zones",
      )
    end

    def service_conf_file
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
