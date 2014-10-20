module Seko
  class Tracking

    attr_accessor :carrier

    DPD = "https://tracking.dpd.de/cgi-bin/delistrack?pknr=:tracking_number&typ=32&lang=en"

    def initialize(carrier, tracking_number)
      @carrier         = carrier
      @tracking_number = tracking_number
    end

    def carrier_destination
      self.class.const_get(carrier.upcase)
    end

    def url
      carrier_destination.gsub(':tracking_number', @tracking_number)
    end

  end
end
