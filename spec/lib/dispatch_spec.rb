require 'spec_helper'
describe Seko::Dispatch do

  describe '.parse_collection' do
    let(:response) { Seko::Response.new(read_json(:dispatch_statuses)) }
    let(:guid_array) { [
      "2b5e52cc-fb6f-4ea4-b8cf-cf64e3a2b8db", 
      "93e92ca2-725a-46f8-90dd-43a16105f78d", 
      "143544ec-f396-4155-95c6-bf59898e0830"
    ] }

    it 'returns the relevant stock info' do
      expect(Seko::Dispatch.parse(response)).to eq(guid_array)
    end
  end

end
