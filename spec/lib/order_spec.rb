require 'spec_helper'
describe Seko::Order do

  let(:email) { "stephen.jones@gmail.com" }

  before do
    Seko.configure(configuration)
  end

  describe '.websubmit' do
    it 'returns a JSON order object for a web order' do
      expected_result = fixture(:order_websubmit)
      expect(Seko::Order.websubmit(order_hash)).to eq(expected_result)
    end
  end

  describe '.submit' do
    it 'returns a JSON order object for a retailer' do
      expected_result = fixture(:order_submit)
      expect(Seko::Order.submit(company_order_hash)).to eq(expected_result)
    end
  end

  describe '.format' do

    it 'returns a Seko ready JSON order object' do
      expected_result = fixture(:order_websubmit)
      expect(Seko::Order.format(order_hash, 'Web')).to eq(expected_result)
    end

  end

  describe '.address' do

    it 'returns JSON format ready address' do
      expected_result = fixture(:order_websubmit)["Request"]["DeliveryDetails"]
      expect(Seko::Order.address(address_hash, email)).to eq(expected_result)
    end

  end

  describe '.line_items' do

    it 'returns JSON format ready line items array' do
      expected_result = fixture(:order_websubmit)["Request"]["List"]["SalesOrderLineItem"]
      expect(Seko::Order.line_items(order_hash)).to eq(expected_result)
    end

  end

  describe '.company' do

    it 'returns JSON format ready company' do
      expected_result = { "ShipToCompany" => fixture(:order_submit)["Request"]["ShipToCompany"] }
      expect(Seko::Order.company(company_hash)).to eq(expected_result)
    end

  end

end
