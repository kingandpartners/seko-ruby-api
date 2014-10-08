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

    def self.format(items)
      {
        "Request" => {
          "List" => {
            "ReceiptLineItem" => line_items(items)
          },
          "Receipt" => {
            "ASNNumber" => Seko.config[:asn_number]
          }  
        }
      }
    end

  end
end