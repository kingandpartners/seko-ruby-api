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
      "FreeQuantity" => "qty", 
      "ProductCode"  => "upc" 
    }

    attr_accessor :token, :response, :type, :request_uri, :path, :service, :endpoint, :options

    def initialize(token, options = {})
      raise "Token is required" unless token

      @token   = token
      @options = default_options.merge(options)
    end

    def send_order_request(order_hash)
      @service  = 'salesorders'
      @endpoint = 'websubmit'
      post(Order.websubmit(order_hash))
    end

    def order_request(order_hash)
      Order.websubmit(order_hash).to_json
    end

    # FIXME: use this method once SS fixes their API
    # for now we are manually sorting the distribution centre
    # see #inventory_response below
    #
    # def get_inventory(warehouse = nil)
    #   @service  = 'stock'
    #   @endpoint = if warehouse.nil?
    #     "all"
    #   else 
    #     "dc/#{warehouse}"
    #   end
    #   inventory_response
    # end
    #
    # def inventory_response
    #   response = get
    #   response.parsed = map_results(Stock.parse(response))
    #   response
    # end

    def get_inventory(warehouse = nil)
      @service  = 'stock'
      @endpoint = 'all'
      inventory_response(warehouse)
    end


    def inventory_response(warehouse = nil)
      response = get
      response.parsed = map_results(Stock.parse(response)).select do |stock|
        warehouse.nil? ? true : stock["DCCode"] == warehouse
      end
      response
    end

    def upcs(inventory)
      inventory.collect { |s| s["upc"] }
    end

    def mapped_inventory(upcs, inventory)
      inventory.collect do |stock| 
        if upcs.include?(stock["upc"])
          { quantity: stock["qty"].to_i }
        end
      end.compact
    end

    def map_results(results)
      results.map { |h| h.inject({ }) { |x, (k,v)| x[map_keys(k)] = v; x } }
    end

    def map_keys(key)
      KEYS_MAP[key] || key
    end

    def submit_product(product_hash)
      @service  = 'products'
      @endpoint = 'submit'
      post(Product.format(product_hash))
    end

    def submit_receipt(line_item_array, warehouse)
      @service  = 'receipts'
      @endpoint = 'submit'
      post(Receipt.format(line_item_array, warehouse))
    end

    def submit_company(company_hash)
      @service  = 'companies'
      @endpoint = 'submit'
      post(Company.format(company_hash))
    end

    def check_grn(guid)
      @service  = 'grns'
      @endpoint = guid
      get
    end

    def order_status(guid)
      @service  = 'salesorders'
      @endpoint = "#{guid}/status"
      get
    end

    def order_tracking(guid)
      @service  = 'salesorders'
      @endpoint = "#{guid}/tracking"
      get
    end

    def cancel_order(guid, reason_code)
      @service  = 'salesorders'
      @endpoint = "#{guid}/cancel/reasoncode/#{reason_code}"
      post({'Cancel' => 'Order'})
    end

    def stock_adjustments(from, to, warehouse)
      @service  = 'stock'
      @endpoint = "adjustment/#{format_from_to(from, to)}"
      get("#{request_uri}&dc=#{warehouse}")
    end

    def stock_movements(from, to, warehouse)
      @service  = 'stock'
      @endpoint = "movement/#{format_from_to(from, to)}"
      get("#{request_uri}&dc=#{warehouse}")
    end

    def dispatch_statuses(from, to, warehouse)
      @service  = 'dispatches'
      @endpoint = "status/#{format_from_to(from, to)}"
      get("#{request_uri}&dc=#{warehouse}&status=Dispatched")
    end

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
        test_mode: true
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

    def build_request(type, url = request_uri)
      request = Net::HTTP.const_get(type).new(url)
      request.content_type = CONTENT_TYPE
      request
    end

    def request(request, json_request = nil)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(request)
      parse_response(response.body)
    end

    def get(url = request_uri)
      request = build_request('Get', url)
      request(request)
    end

    def post(json_request, url = request_uri)
      request      = build_request('Post', url)
      request.body = json_request.to_json
      request(request)
    end

    def parse_response(json_response)
      log(json_response)
      @response = Response.new(json_response)
    end

    def format_from_to(from, to)
      "#{from.strftime('%F')}T00:00:00Z/#{to.strftime('%F')}T00:00:00Z"
    end

  end
end
