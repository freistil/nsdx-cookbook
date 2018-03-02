module Nsdx
  class ZoneRegistry
    def initialize(node)
      @node = node
      @node.run_state[COOKBOOK] = {} unless @node.run_state.key?(COOKBOOK)
    end

    def zone(zone_name)
      if @node.run_state[COOKBOOK].key?(zone_name)
        @node.run_state[COOKBOOK][zone_name]
      else
        zone = Zone.new(name: zone_name)
        @node.run_state[COOKBOOK][zone_name] = zone
        zone
      end
    end

    def zones
      @node.run_state[COOKBOOK].keys
    end
  end
end
