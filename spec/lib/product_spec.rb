require 'spec_helper'
describe Seko::Product do

  let(:product_hash)  { { upc: 123456, description: "A Test Product" } }

  before do
    Seko.configure(configuration)
  end

  describe '.supplier' do
    it 'reads supplier deatils from config' do
      expect(Seko.config).to eq(configuration)
    end
  end

  describe '.format' do
    it 'formats a simple product hash into a fully formed JSON ready hash' do
      expected_result = fixture(:product_submit)
      expect(Seko::Product.format(product_hash)).to eq(expected_result)
    end
  end

end
