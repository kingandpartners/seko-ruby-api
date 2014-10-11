# Seko

[![Build Status](https://travis-ci.org/jGRUBBS/seko-ruby-api.svg?branch=master)](https://travis-ci.org/jGRUBBS/seko-ruby-api.svg?branch=master)

Ruby wrapper for Seko Logistics' SupplyStream iHub REST API v1

[SupplyStream REST API Documentation](https://wiki.supplystream.com/GetFile.aspx?Page=MANUAL.Integration-Hub-Rest-APIs&File=integration-ihub-rest-apis-v1.4.pdf)

## Possible Integrations

1.  **Inbound Product Master Upload and method**
2.  **Inbound Companies Upload and method**
3.  **Inbound Advanced Shipment Notification**
4.  **Inbound Sales Order**
5.  Retrieve GRN’s
6.  **Retrieve Stock Quantity**
7.  Retrieve Tracking Details
8.  Retrieve Sales Order Status
9.  Retrieve Stock Adjustments
10. Retrieve Stock Movements

## Process

1.  Sellect or K&P need to load product masters in SS through the UAT Integration Hub or
2.  Please provide these to me on a CSV file as per the template attached and I will load these using the manual upload function in the UAT integration hub
3.  Receipts (ASN’s) need to be sent to SS through the UAT Integration Hub or
4.  I will upload a few lines of the products on the attached template using the manual upload function in the UAT Integration Hub
5.  I will the create the GRN’s in SS
6.  Sellect or K&P will then be able to retrieve the GRN’s and Stock Quantities
7.  Sellect or K&P will then need to send Sales Orders on products that have available Stock
8.  These can be sent to DCCL01 (UK Warehouse) or DCSOM01 (US Warehouse)
9.  I will then pick, pack and dispatch the orders in SS
10. Sellect or K&P can then retrieve sales order status, dispatch status and dispatch (tracking) details


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
#### Configuration
config/initializers/seko.rb
```ruby
Seko.configure(
  supplier_code:        'DEFSUPLJLTD001',
  supplier_description: 'Default Supplier LARSSON & JENNINGS LTD',
  supplier_uom:         1
)
```

#### Submit Product

```ruby
client   = Seko::Client.new("token")
response = client.submit_product(upc: "123456", description: 'A test product')
```

#### Submit Receipt

```ruby
line_item_array = [ { id: 1, upc: "123456", quantity: 10 } ]
warehouse  = 'DC123'
client     = Seko::Client.new("token")
response   = client.submit_receipt(line_item_array, warehouse)
```

#### Get Stock

```ruby
client     = Seko::Client.new("token")
response   = client.get_inventory
```

#### Submit Order

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
  warehouse:    "DC123",
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
