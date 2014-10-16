module Seko
  class Dispatch

    def self.parse(response)
      response.root_response["List"]["DispatchLineItem"].collect do |h|
        h["GUID"]
      end
    end

  end
end
