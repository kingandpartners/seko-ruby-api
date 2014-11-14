require 'spec_helper'
describe Seko::Tracking do

  let(:dpd_url)      { 'http://www.dpd.co.uk/apps/tracking/?reference=:tracking_number&postcode=#results' }
  let(:ups_url)      { 'http://wwwapps.ups.com/WebTracking/track?trackNums=:tracking_number&track.x=Track' }
  let(:ups_number)   { '1Z87932WD945835927' }
  let(:dpd_number)   { '15503259038100Z' }
  let(:ups_tracking) { Seko::Tracking.new('', ups_number) }
  let(:dpd_tracking) { Seko::Tracking.new('', dpd_number) }

  describe '#get_carrier' do
    it 'returns the carrier based on a regular expression match' do
      expect(ups_tracking.get_carrier).to eq('UPS')
      expect(dpd_tracking.get_carrier).to eq('DPD')
    end
  end

  describe '#carrier_destination' do
    it 'returns the tracking url for the provided carrier' do
      expect(ups_tracking.carrier_destination).to eq(ups_url)
      expect(dpd_tracking.carrier_destination).to eq(dpd_url)
    end
  end

  describe '#url' do
    it 'returns the final tracking url' do
      ups_tracking_number = ups_url.gsub(':tracking_number', ups_number)
      dpd_tracking_number = dpd_url.gsub(':tracking_number', dpd_number)
      expect(ups_tracking.url).to eq(ups_tracking_number)
      expect(dpd_tracking.url).to eq(dpd_tracking_number)
    end
  end

end