require 'net/https'
require 'json'

module Seko
  class Client

    PORT         = 443
    TEST_HOST    = 'hubuat1.supplystream.com'
    LIVE_HOST    = 'api.supplystream.com'
    API_PATH     = '/hub/api/'
    API_VERSION  = 'v1'
    CONTENT_TYPE = 'application/json'
    KEYS_MAP     = { 
      "FreeQuantity" => "quantity", 
      "ProductCode"  => "upc" 
    }

    attr_accessor :token, :response, :type, :request_uri, :path, :service, :endpoint

    def initialize(token, options = {})
      raise "Token is required" unless token

      @token   = token
      @options = default_options.merge!(options)
    end

    # def send_order_request(order)
    #   # request  = order_request(order)
    #   # @path    = Order::PATH
    #   # post(request)
    # end

    def get_inventory
      @service  = 'stock'
      @endpoint = 'all'
      response  = Response.new(inventory_request.body)
      response.parsed = map_results(Stock.parse(response))
      response
    end

    def inventory_request
      get(request_uri)
    end

    def submit_product(product_hash)
      @service  = 'products'
      @endpoint = 'submit'
      post(Product.format(product_hash))
    end

    def submit_receipt(line_item_array)
      @service  = 'receipts'
      @endpoint = 'submit'
      post(Receipt.format(line_item_array))
    end

    # def order_request(order)
    #   # @path = Order::PATH
    #   # Order.new(self).build_order_request(order)
    # end

    # def upcs(inventory)
    #   # inventory.collect { |s| s["upc"] }
    # end

    # def mapped_inventory(upcs, inventory)
    #   # inventory.collect do |stock| 
    #   #   if upcs.include?(stock["upc"])
    #   #     { quantity: stock["qty"].to_i }
    #   #   end
    #   # end.compact
    # end

    def request_uri
      "https://#{host}#{path}?token=#{token}"
    end

    def path
      "#{API_PATH}#{service}/#{API_VERSION}/#{endpoint}.json"
    end

    private
    def default_options
      { 
        verbose: true,
        test_mode: true # FIXME: change once testing is complete
      }
    end

    def testing?
      @options[:test_mode]
    end

    def verbose?
      @options[:verbose]
    end

    def host
      testing? ? TEST_HOST : LIVE_HOST 
    end

    def log(message)
      return unless verbose?
      puts message
    end

    def http
      @http ||= Net::HTTP.new(host, PORT)
    end

    def request(json_request)
      request              = Net::HTTP::Post.new(request_uri)
      request.body         = json_request.to_json
      request.content_type = CONTENT_TYPE
      http.use_ssl         = true
      http.verify_mode     = OpenSSL::SSL::VERIFY_NONE
      http.request(request)
    end

    def get(url)
      request = Net::HTTP::Get.new(URI(url))
      request.content_type = CONTENT_TYPE
      http.use_ssl         = true
      http.verify_mode     = OpenSSL::SSL::VERIFY_NONE
      response = http.request(request)
    end

    def post(json_request)
      response = request(json_request)
      parse_response(response.body)
    end

    def parse_response(json_response)
      log(json_response)
      @response = Response.new(json_response)
    end

    def map_results(results)
      results.map do |h|
        h.inject({ }) { |x, (k,v)| x[map_keys(k)] = v; x }
      end
    end

    def map_keys(key)
      KEYS_MAP[key] || key
    end

  end
end
