require 'spec_helper'
describe Seko::Filter do

  describe '.parse' do
    let(:unfiltered) { "test | this" }
    let(:expected)   { "test - this" }
    it 'removes | characters' do
      expect(Seko::Filter.parse(unfiltered)).to eq (expected)
    end
  end

end