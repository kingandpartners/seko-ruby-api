0.0.10
-----------
**FIXES**
- make courier attributes on order optional. With the addition of the `has_courier?` method, you can now pass either `N/A` or a blank `order[:shipping_carrier]` to exclude courier from the order submission.

0.0.9
-----------
**FIXES**
- pass separate value, `order[:shipping_carrier]`, to `CourierName`

0.0.8
-----------
**FIXES**
- rename `State` to `County` as `State` was not recongnized by Seko

0.0.7
-----------
**NEW FEATURES**
- add `State`, `CourierName`, and `CourierService` to order

0.0.6
-----------
**NEW FEATURES**
- rename `submit_receipt` to `send_return_request` to be more semantic
- add `requires_warehouse?` method for third-party use

0.0.5
-----------
**NEW FEATURES**
- add `UnitPrice`, `CurrencyCode`, and `VAT` to order line items.

0.0.4
-----------
**NEW FEATURES**
- add tracking for UPS
- `get_carrier` method now parses tracking numbers with a RegEx and returns the appropriate carrier

0.0.3
-----------
**FIXES**
- pass dashes when zipcode is blank

0.0.2
-----------
**FIXES**
- update DPD tracking url

0.0.1
-----------
- initial release using Seko Logistics' SupplyStream iHub REST API v1
**Integrations**
1.  **Inbound Product Master Upload and method**
2.  **Inbound Companies Upload and method**
3.  **Inbound Advanced Shipment Notification**
4.  **Inbound Sales Order / Cancel Orders**
5.  **Retrieve GRN’s**
6.  **Retrieve Stock Quantity**
7.  **Retrieve Tracking Details**
8.  **Retrieve Sales Order Status**
9.  **Retrieve Stock Adjustments**
10. **Retrieve Stock Movements**