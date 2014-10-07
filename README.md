# Seko

Ruby wrapper for Seko Logistics' SupplyStream iHub REST API

[SupplyStream REST API Documentation](https://wiki.supplystream.com/GetFile.aspx?Page=MANUAL.Integration-Hub-Rest-APIs&File=integration-ihub-rest-apis-v1.4.pdf)

## Possible Integrations

1.  Inbound Product Master Upload and method (via Integration or Manual csv upload)
2.  Inbound Companies Upload and method (via Integration or Manual csv upload)
3.  Inbound Advanced Shipment Notification (via Integration or Manual csv upload)
4.  **Inbound Sales Order (Integration)**
5.  Retrieve GRN’s
6.  **Retrieve Stock Quantity**
7.  Retrieve Tracking Details
8.  Retrieve Sales Order Status
9.  Retrieve Stock Adjustments
10. Retrieve Stock Movements

## Questions

- does Seko / SupplyStream provide shipment notifications to a specified end-point?

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seko'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seko

## Usage

```ruby

order = {
  carrier: "FEDEX",
  billing_address:  { 
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  shipping_address: {
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  gift_wrap:    "true",
  gift_message: "Happy Birthday!",
  email:        "someone@somehwere.com",
  number:       "R123123123",
  type:         "OO",
  line_items: [
    {
      price:    "127.23",
      quantity: "1",
      sku:      "123332211",
      size:     "XS"
    }
  ],
  shipping_code: "90",
  invoice_url:   "http://example.com/R123123123/invoice"
}

client   = Seko::Client.new("token")
response = client.send_order_request(order)

if response.success?
  # DO SOMETHING
else
  # QUEUE REQUEST, STORE AND RAISE ERRORS
end

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/seko/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
