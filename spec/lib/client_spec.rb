require 'spec_helper'
describe Seko::Client do

  let(:token)  { 'abc123' }
  let(:client) { Seko::Client.new(token, { test_mode: true }) }

  describe '#get_inventory' do
    it 'gets a JSON collection of stock objects and normalizes the quantity and upc fields' do
      stub_get("stock/v1/all.json").with(query: {token: token}).
        to_return(body: fixture(:stock).to_json, headers: json_headers)
      response = client.get_inventory
      expect(response.parsed.map { |x| x["quantity"] }).to eq([0, 10, 20])
      expect(response.parsed.map { |x| x["upc"] }).to eq([100014, 100015, 100016])
    end
  end

  describe '#submit_product' do

    let(:product_hash) { { test: '123' } }

    it 'returns a succesful response' do
      stub_post("products/v1/submit.json").with(query: {token: token}).
        to_return(status: 200, body: success_response.to_json, headers: json_headers)
      expect(Seko::Product).to receive(:format).with(product_hash)
      response = client.submit_product(product_hash)
      expect(response.success?).to eq(true)
    end

  end

end
