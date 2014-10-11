module Seko
  class Stock

    def self.parse(response)
      response.root_response["List"]["StockQuantityLineItem"]
    end

  end
end
