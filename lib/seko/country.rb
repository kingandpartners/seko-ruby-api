module Seko
  class Country

    COUNTRY_MAP = {
      # FIXME: need country format
      # map countries
    }

    def self.map(code)
      COUNTRY_MAP[code] || code
    end


  end
end