module Seko
  class Response

    attr_accessor :raw, :parsed

    def initialize(response)
      @raw    = response
      @parsed = JSON.parse(response)
    end

    def root_response
      @parsed["Response"].nil? ? @parsed : @parsed["Response"]
    end

    def success?
      root_response["CallStatus"]["Success"]
    end

    def failure?
      !success?
    end

    def message
      message = root_response["CallStatus"]["Message"]
      message.empty? ? "" : message
    end

  end
end
