require 'spec_helper'
describe Seko::Response do

  let(:guid)             { 'f66fd245-7b9e-4fd2-9dbf-5631edc875d9' }
  let(:failed_response)  { "{\n \"CallStatus\": {\n \"Success\": false, \"Message\": \"Failed!\" } }" }
  let(:errant_raw)       { "{\n \"CallStatus\": {\n \"Success\": true, \"Message\": {} }, \"GUID\": \"#{guid}\" }" }
  let(:raw_response)     { "{\"Response\": #{errant_raw}}" }
  let(:parsed_response)  { JSON.parse(raw_response) }
  let(:response)         { Seko::Response.new(raw_response) }
  let(:errant_response)  { Seko::Response.new(errant_raw) }
  let(:failure_response) { Seko::Response.new(failed_response) }

  describe '#initialize' do
    it 'sets the raw and parsed response' do
      expect(response.raw).to eq(raw_response)
      expect(response.parsed).to eq(parsed_response)
    end
  end

  describe '#root_response' do
    it 'fixes an issue in the API were sometimes the "Response" object is present and sometimes it is not' do
      expect(errant_response.root_response).to eq(response.root_response)
    end
  end

  describe '#success?' do
    it 'checks and returns the proper field in repsonse object for success' do
      expect(response.success?).to be(true)
      expect(failure_response.success?).to be(false)
    end
  end

  describe '#failure?' do
    it 'is the opposite of success' do
      expect(response.failure?).to be(false)
      expect(failure_response.failure?).to be(true)
    end
  end

  describe '#message' do
    it 'returns the message of the repsonse' do
      expect(failure_response.message).to eq('Failed!')
      expect(response.message).to eq('')
    end
  end

  describe '#guid' do
    it 'returns the GUID from the response' do
      expect(response.guid).to eq(guid)
    end
  end

end