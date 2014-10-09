module Seko
  class Order

    def self.websubmit(attributes)
      format(attributes)
    end

    def self.submit(attributes)
      format(attributes)["Request"].merge(company(attributes[:company]))
    end

    def self.company(company)
      "ShipToCompany" => {
        "CompanyCode"        => "IND001",
        "CompanyDescription" => "Indigina"
      }
    end

    def self.format(order)
      {
        "Request" => {
          "DeliveryDetails"      => address(order[:address], order[:email]),
          "List" => {
            "SalesOrderLineItem" => line_items(order[:line_items])
          },
          "SalesOrder" => {
            "SalesOrderDate"     => order[:date]
            "SalesOrderNumber"   => order[:number]
          }
        }
      }
    end

    def self.address(address, email)
      {
        "City"         => address[:city],
        "CountryCode"  => Country.map(address[:country]),
        "EmailAddress" => email,
        "FirstName"    => address[:first_name],
        "LastName"     => address[:last_name],
        "Line1"        => address[:address1],
        "Line2"        => address[:address2],
        "PhoneNumber"  => address[:phone],
        "PostcodeZip"  => address[:zipcode]
      }
    end

    def self.line_items(items)
      items.collect.with_index do |line_item, index|
        {
          "LineNumber"  => index,
          "ProductCode" => line_item[:sku],
          "Quantity"    => line_item[:quantity]
        }
      end
    end

  end
end