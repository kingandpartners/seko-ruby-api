module Seko
  class Response

    def initialize(response)
      @raw    = response
      @parsed = JSON.parse(response)
    end

    def success?
      @parsed["Response"]["CallStatus"]["Success"]
    end

    def failure?
      !success?
    end

  end
end