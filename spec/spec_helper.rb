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
      },
      "GUID" => "3ea9eb61-7f49-4c03-986a-9340da72c6d4"
    }
  }
end