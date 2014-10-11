module Seko
  class Receipt

    def self.line_items(items)
      items.map do |item|
        {
          "LineNumber"  => item[:id],
          "ProductCode" => item[:upc],
          "Quantity"    => item[:quantity],
          "SupplierCompanyCode" => Seko.config[:supplier_code]
        }
      end
    end

    def self.format(items, warehouse)
      {
        "Request" => {
          "List" => {
            "ReceiptLineItem" => line_items(items)
          },
          "Receipt" => {
            "ASNNumber" => random_asn
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
