module Nsdx
  class Zone
    attr_reader :name, :records

    def initialize(params)
      @name = params[:name]
      @records = []
    end

    def add_record(record)
      @records << record
    end
  end
end
