module Seko
  class Product

    def self.supplier
      {
        "SupplierCode"        => Seko.config[:supplier_code],
        "SupplierDescription" => Seko.config[:supplier_description],
        "UOM"                 => Seko.config[:supplier_uom]
      }
    end

    def self.format(attributes)
      {
        "Request" => {
          "List" => {
            "SupplierMapping" => supplier
          },
          "ProductMaster" => {
            "ProductCode"        => attributes[:upc],
            "ProductDescription" => attributes[:description]
          }
        }
      }
    end

  end
end