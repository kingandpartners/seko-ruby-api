require 'bundler/setup'
Bundler.setup

require 'seko'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end

def fixture(type)
  JSON.parse(File.read(File.expand_path("spec/fixtures/#{type}.json")))
end

def base_url
  "https://hubuat1.supplystream.com/hub/api/"
end

def stub_get(path)
  stub_request(:get, "#{base_url}#{path}")
end

def stub_post(path)
  stub_request(:post, "#{base_url}#{path}")
end

def json_headers
  {content_type: "application/json; charset=utf-8"}
end

def json_post_headers
  {
    'Accept'=>'*/*', 
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
    'Content-Type'=>'application/json', 
    'User-Agent'=>'Ruby'
  }
end

def success_response
  {
    "Response" => {
      "CallStatus" => {
        "Code"     => 0,
        "Message"  => {},
        "Success"  => true
      }
    }
  }
end

def error_product_response
  {
    "CallStatus" => {
      "Success" => false,
      "Code" => 100,
      "Message" => "Error Submitting Product Master: LJ-W-BERN-S-GW - Error. Product Code already exists."
    }
  }
end

def configuration
  { 
    supplier_code: "Supplier1", 
    supplier_description: "My Supplier", 
    supplier_uom: 1,
    asn_number: 123456
  }
end