require 'spec_helper'
describe Seko::Client do

  let(:token)  { 'abc123' }
  let(:client) { Seko::Client.new(token, { test_mode: true }) }

  describe '#get_inventory' do
    it 'gets a JSON collection of stock objects and normalizes the quantity and upc fields' do
      stub_get("stock/v1/all.json").with(query: {token: token}).
        to_return(body: fixture(:stock), headers: json_headers)
      response = client.get_inventory
      expect(response.map { |x| x["quantity"] }).to eq([0, 10, 20])
      expect(response.map { |x| x["upc"] }).to eq([100014, 100015, 100016])
    end
  end

  describe '#submit_product' do
    it 'submits a product' do
      stub_post("products/v1/submit.json").with(query: {token: token}).
        to_return(body: fixture(:stock), headers: json_headers)
      response = client.get_inventory
      expect(response.map { |x| x["quantity"] }).to eq([0, 10, 20])
      expect(response.map { |x| x["upc"] }).to eq([100014, 100015, 100016])
    end
  end

end
