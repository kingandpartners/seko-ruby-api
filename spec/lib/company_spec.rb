require 'spec_helper'
describe Seko::Company do

  before do
    Seko.configure(configuration)
  end

  describe '.format' do
    it 'formats a simple company hash into a fully formed JSON ready hash' do
      expected_result = fixture(:company_submit)
      expect(Seko::Company.format(company_submit_hash)).to eq(expected_result)
    end
  end

  describe '.address' do
    it 'formats a simple address hash into a fully formed JSON ready hash' do
      expected_result = fixture(:company_submit)["Request"]["List"]["Address"]
      expect(Seko::Company.address(company_address_hash)).to eq(expected_result)
    end
  end

end
