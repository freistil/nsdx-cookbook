module Nsdx
  class ResourceRecordFactory
    def self.record(record_hash)
      case record_hash[:type]
      when "A"
        ARecord.new(record_hash)
      when "MX"
        MxRecord.new(record_hash)
      when "CNAME"
        CnameRecord.new(record_hash)
      when "SPF"
        SpfRecord.new(record_hash)
      when "TXT"
        TxtRecord.new(record_hash)
      end
    end
  end
end
