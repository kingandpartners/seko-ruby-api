module Seko
  class Order

    def self.websubmit(attributes)
      format(attributes, "Web")
    end

    def self.submit(attributes)
      formatted = format(attributes)
      formatted["Request"].merge!(company(attributes[:company]))
      formatted
    end

    def self.format(order, order_prefix = nil)
      {
        "Request" => {
          "DeliveryDetails"      => address(order[:address], order[:email]),
          "List" => {
            "SalesOrderLineItem" => line_items(order[:line_items])
          },
          "SalesOrderHeader" => { "DCCode" => order[:warehouse] },
          "#{order_prefix}SalesOrder" => {
            "SalesOrderDate"     => order[:date],
            "SalesOrderNumber"   => order[:number]
          }
        }
      }
    end

    def self.address(address, email)
      {
        "City"         => address[:city],
        "CountryCode"  => address[:country],
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
          "LineNumber"  => index + 1,
          "ProductCode" => line_item[:sku],
          "Quantity"    => line_item[:quantity]
        }
      end
    end

    def self.company(company)
      {
        "ShipToCompany" => {
          "CompanyCode"        => company[:code],
          "CompanyDescription" => company[:description]
        }
      }
    end

  end
end
