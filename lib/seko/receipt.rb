module Seko
  class Receipt

    def self.line_items(items)
      items.map.collect.with_index do |item, index|
        {
          "LineNumber"  => index + 1,
          "ProductCode" => item[:upc],
          "Quantity"    => item[:quantity],
          "SupplierCompanyCode" => Seko.config[:supplier_code]
        }
      end
    end

    def self.format(return_auth, warehouse)
      {
        "Request" => {
          "List" => {
            "ReceiptLineItem" => line_items(return_auth[:line_items])
          },
          "Receipt" => {
            "ASNNumber"   => random_asn,
            "HBReference" => return_auth[:number],
            "IsReturn"    => true
          },
          "ReceiptHeader" => {
            "DCCode" => warehouse
          }
        }
      }
    end

    def self.random_asn
      rand.to_s[2..11]
    end

  end
end
