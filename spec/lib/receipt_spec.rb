require 'spec_helper'
describe Seko::Receipt do

  let(:line_items_array) do
    [
      { id: 1, upc: 100083, quantity: 10 },
      { id: 2, upc: 100076, quantity: 15 }
    ]
  end

  before do
    Seko.configure(configuration)
  end

  describe '.line_items' do
    it 'structures line items into JSON ready hash' do
      expected_result = fixture(:receipt_submit)["Request"]["List"]["ReceiptLineItem"]
      expect(Seko::Receipt.line_items(line_items_array)).to eq(expected_result)
    end
  end

  describe '.format' do
    it 'formats a fully formed JSON ready hash for receipt' do
      expected_result = fixture(:receipt_submit)
      expect(Seko::Receipt.format(line_items_array)).to eq(expected_result)
    end
  end

end
