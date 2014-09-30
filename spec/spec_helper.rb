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

def stub_get(path)
  stub_request(:get, "https://hubuat1.supplystream.com/hub/api/#{path}")
end

def json_headers
  {content_type: "application/json; charset=utf-8"}
end