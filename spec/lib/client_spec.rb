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
      product_hash = {test: '123'}
      stub_post("products/v1/submit.json").
        to_return(status: 200, body: success_response.to_json, headers: json_headers)
      expect(Seko::Product).to receive(:new).with(product_hash)
      response = client.submit_product(product_hash)
      expect(response.success?).to eq(true)
    end
  end

end
