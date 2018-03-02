module Nsdx
  class ResourceRecord
    attr_reader :host, :type, :zone

    def initialize(record_hash)
      @host = record_hash[:host] || "@"
      @type = record_hash[:type]
      @zone = record_hash[:zone]
    end

    def bind9entry
      raise NotImplementedError
    end
  end

  class ARecord < ResourceRecord
    attr_reader :ip_address

    def initialize(record_hash)
      super
      @ip_address = record_hash[:ip_address]
    end

    def bind9entry
      format("%-20s IN A     %s", host, ip_address)
    end
  end

  class MxRecord < ResourceRecord
    attr_reader :preference, :mx

    def initialize(record_hash)
      super
      @preference = record_hash[:preference]
      @mx = record_hash[:mx]
    end

    def bind9entry
      format("%-20s IN MX    %s %s", host, preference, mx)
    end
  end

  class CnameRecord < ResourceRecord
    attr_reader :cname

    def initialize(record_hash)
      super
      @cname = record_hash[:cname]
    end

    def bind9entry
      format("%-20s IN CNAME %s", host, cname)
    end
  end

  class SpfRecord < ResourceRecord
    attr_reader :policy

    def initialize(record_hash)
      super
      @policy = record_hash[:policy]
    end

    def bind9entry
      format('%-20s IN TXT   "%s"', host, policy)
    end
  end

  class TxtRecord < ResourceRecord
    attr_reader :text

    def initialize(record_hash)
      super
      @text = record_hash[:text]
    end

    def bind9entry
      format('%-20s IN TXT   "%s"', host, text)
    end
  end
end
