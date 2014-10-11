require 'spec_helper'
describe Seko::Stock do

  describe '.parse' do
    it 'returns the relevant stock info' do
      expected_result = fixture(:stock)["Response"]["List"]["StockQuantityLineItem"]
      response        = Seko::Response.new(read_json(:stock))
      expect(Seko::Stock.parse(response)).to eq(expected_result)
    end
  end

end