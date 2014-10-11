module Seko
  class Company

    def self.format(company)
      {
        "Request" => {
          "Company" => {
            "CompanyCode"        => company[:code],
            "CompanyDescription" => company[:description],
            "CompanyType"        => "Ship To"
          },
          "List" => {
            "Address" => address(company[:address])
          }
        }
      }
    end

    def self.address(address)
      {
        "AddressLine1" => address[:address1],
        "AddressLine2" => address[:address2],
        "AddressLine3" => address[:address3],
        "AddressType"  => "Delivery",
        "City"         => address[:city],
        "CountryCode"  => address[:country],
        "County"       => address[:country_name],
        "PostcodeZip"  => address[:zipcode]
      }
    end

  end
end
