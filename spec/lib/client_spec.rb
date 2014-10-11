require 'spec_helper'
describe Seko::Client do

  let(:token)        { 'abc123' }
  let(:options)      { { verbose: true, test_mode: true } }
  let(:live_options) { { verbose: false, test_mode: false } }
  let(:client)       { Seko::Client.new(token, options) }
  let(:live_client)  { Seko::Client.new(token, live_options) }

  describe '#initialize' do
    it 'sets the @token and @options' do
      expect(client.token).to eq(token)
      expect(client.options).to eq(options)
    end
  end

  describe '#send_order_request' do
    before do
      stub_post("salesorders/v1/websubmit.json").with(query: {token: token}).
        to_return(body: success_response.to_json, headers: json_headers)
    end

    let(:response) { client.send_order_request(order_hash) }

    it 'sends an POST request with an order object' do
      expect(response.success?).to eq(true)
    end
  end

  describe 'inventory methods' do
    before do
      stub_get("stock/v1/all.json").with(query: {token: token}).
        to_return(body: fixture(:stock).to_json, headers: json_headers)
    end

    let(:response)     { client.get_inventory }
    let(:upc_array)    { [100014, 100015, 100016] }
    let(:raw_response) { read_json(:stock) }

    describe '#get_inventory' do
      before { response }

      it 'sets service and enpoints on the client' do
        expect(client.service).to eq('stock')
        expect(client.endpoint).to eq('all')
      end

      it 'returns a Seko::Response object' do
        expect(response).to be_a(Seko::Response)
      end
    end

    describe '#inventory_request' do
      it 'makes HTTP request and builds Seko::Response object' do
        parsed = client.map_results(Seko::Stock.parse(Seko::Response.new(raw_response)))
        expect(response.parsed).to eq(parsed)
        expect(JSON.parse(response.raw)).to eq(JSON.parse(raw_response))
      end
    end


    describe '#upcs' do
      it 'returns array of upcs' do
        expect(client.upcs(response.parsed)).to eq(upc_array)
      end
    end

    describe '#mapped_inventory' do
      it 'maps inventory into a collection of simple hashes' do
        expected_collection = [{ quantity: 0  }, { quantity: 10 }, { quantity: 20 }]
        expect(client.mapped_inventory(upc_array, response.parsed)).to eq(expected_collection)
      end
    end

    describe '#map_results' do
      it 'normalizes the quantity and upc fields' do
        expect(response.parsed.map { |x| x["qty"] }).to eq([0, 10, 20])
        expect(response.parsed.map { |x| x["upc"] }).to eq(upc_array)
      end
    end

    describe '#map_keys' do
      it 'maps verbose keys to simpler keys' do
        expect(client.send(:map_keys, "FreeQuantity")).to eq('qty')
        expect(client.send(:map_keys, "ProductCode")).to eq('upc')
      end
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

  describe '#submit_receipt' do
    before do
      stub_post("receipts/v1/submit.json").with(query: {token: token}).
        to_return(body: success_response.to_json, headers: json_headers)
    end

    let(:response) { client.submit_receipt(line_items_array, order_hash[:warehouse]) }

    it 'sends an POST request with a receipt object' do
      expect(response.success?).to eq(true)
    end
  end

  describe '#submit_company' do
    before do
      stub_post("companies/v1/submit.json").with(query: {token: token}).
        to_return(body: success_response.to_json, headers: json_headers)
    end

    let(:response) { client.submit_company(company_submit_hash) }

    it 'sends an POST request with a company object' do
      expect(response.success?).to eq(true)
    end
  end

  describe '#request_uri' do
    it 'builds the request URI' do
      expect(client).to receive(:host).and_return('test.com/')
      expect(client).to receive(:path).and_return('test')
      expect(client).to receive(:token).and_return('abc123')
      expect(client.request_uri).to eq("https://test.com/test?token=abc123")
    end
  end

  describe '#path' do
    it 'builds the URI path' do
      expect(client).to receive(:service).and_return('test')
      expect(client).to receive(:endpoint).and_return('testendpoint')
      expect(client.path).to eq("/hub/api/test/v1/testendpoint.json")
    end
  end

  describe 'private methods' do

    describe '#default_options' do
      it 'returns default options' do
        expect(client.send(:default_options)).to eq({ verbose: true, test_mode: true })
      end
    end

    describe '#testing?' do
      it 'returns a boolean to check test mode' do
        expect(client.send(:testing?)).to      eq(true)
        expect(live_client.send(:testing?)).to eq(false)
      end
    end

    describe '#verbose?' do
      it 'returns a boolean to check whether to log results or not' do
        expect(client.send(:verbose?)).to      eq(true)
        expect(live_client.send(:verbose?)).to eq(false)
      end
    end

    describe '#host' do
      it 'returns host depending of test mode' do
        expect(client.send(:host)).to      eq(Seko::Client::TEST_HOST)
        expect(live_client.send(:host)).to eq(Seko::Client::LIVE_HOST)
      end
    end

    describe '#log' do
      it 'logs messages when verbose mode is set' do
        expect { client.send(:log, 'test') }.to          output(/test/).to_stdout
        expect { live_client.send(:log, 'test') }.to_not output(/test/).to_stdout
      end
    end

    describe '#http' do
      it 'returns a Net::HTTP object' do
        expect(client.send(:http)).to be_a(Net::HTTP)
      end
    end

    describe '#build_request' do

      let(:get_request)  { client.send(:build_request, 'Get') }
      let(:post_request) { client.send(:build_request, 'Post') }

      it 'builds a net/https request' do
        expect(get_request).to  be_a(Net::HTTP::Get)
        expect(post_request).to be_a(Net::HTTP::Post)
        expect(get_request.content_type).to eq(Seko::Client::CONTENT_TYPE)
      end
    end

    describe '#request' do
      it 'sets the ssl and verify mode, sends an http request, and returns a response object' do
        expect(client.send(:http)).to receive(:request).and_return(fake_response)
        expect(client.send(:request, 'Get')).to be_a(Seko::Response)
        expect(client.send(:http).use_ssl?).to be(true)
        expect(client.send(:http).verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
      end
    end

    describe '#get' do
      it 'builds and makes a GET request' do
        expect(client).to receive(:build_request)
        expect(client).to receive(:request)
        client.send(:get)
      end
    end

    describe '#post' do
      it 'builds and makes a POST request' do
        expect(client).to receive(:request)
        client.send(:post, { test: true })
      end
    end

    describe '#parse_response' do
      let(:json_response) { {test: true}.to_json }

      it 'logs response' do
        expect(client).to receive(:log).with(json_response)
        client.send(:parse_response, json_response)
      end

      it 'parses response into a Seko::Response object' do
        expect(client.send(:parse_response, json_response)).to be_a(Seko::Response)
      end
    end

  end

end
