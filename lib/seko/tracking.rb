module Seko
  class Tracking

    attr_accessor :carrier

    DPD = "http://www.dpd.co.uk/apps/tracking/?reference=:tracking_number&postcode=#results"
    UPS = "http://wwwapps.ups.com/WebTracking/track?trackNums=:tracking_number&track.x=Track"

    TRACKING_NUMBERS = {
      'UPS' => /\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d\d\d ?\d\d\d\d ?\d\d\d)\b/i,
      'DPD' => /\b([0-9]{14} ?[A-Z]{1})/i
    }

    def get_carrier
      TRACKING_NUMBERS.each do |carrier, pattern|
        return carrier.dup if @tracking_number =~ pattern 
      end
      return 'DPD' # return DPD by default
    end

    def initialize(carrier, tracking_number)
      # FIXME: dependent apps currently rely on two arguments 
      # (carrier and tracking_number) therefore we should keep 
      # carrier, but should removed in next minor level release
      @tracking_number = tracking_number
      @carrier         = get_carrier
    end

    def carrier_destination
      self.class.const_get(carrier.upcase)
    end

    def url
      carrier_destination.gsub(':tracking_number', @tracking_number)
    end

  end
end
