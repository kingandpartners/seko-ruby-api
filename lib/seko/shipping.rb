module Seko
  class Shipping

    OPTIONS = {
      # UK
      "BEFORE 10"       => "PLPRE1000",
      "BEFORE 12"       => "PLPRE1200",
      "NEXT DAY"        => "PLNEXTDAY",
      "TWO DAY"         => "PLECO48",
      "SAT B4 10"       => "PLSATB410",
      "SAT B4 12"       => "PLSATB412",
      # EU
      "EU BY AIR"       => "PLCP-EU",
      # NOT SURE
      "DOCUMENT BY AIR" => "PLCP-WED",
      "PARCEL BY AIR"   => "PLNEXTCP-WEP",
      "PARCEL DPD"      => "PLDPD",
      "SATURDAY"        => "PLSAT"
    }

    def map(key)
      OPTIONS[key] || key
    end

  end
end