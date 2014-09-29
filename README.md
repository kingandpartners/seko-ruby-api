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

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/seko/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
