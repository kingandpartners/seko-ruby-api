module Seko
  class Tracking

    attr_accessor :carrier

    DPD = "http://www.dpd.co.uk/apps/tracking/?reference=:tracking_number&postcode=#results"

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
