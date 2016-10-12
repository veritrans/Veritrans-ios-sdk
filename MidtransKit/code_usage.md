
//Create items

```
NSMutableArray *items = [NSMutableArray new];
for (int i=0; i<6; i++) {
	VTItem *item = [VTItem itemWithId:<item id> name:<name> price:<price> imageURL:<item image> quantity:<quantity>];
	[items addObject:item];
}
```

//Create address object

```
VTAddress *address = [VTAddress addressWithFirstName:<first name> lastName:<last name> phone:<phone> address:<address> city:<city> postalCode:<postal code> countryCode:<country code>];
```

//Create customer object

```
VTCustomerDetails *customer = [[VTCustomerDetails alloc] initWithFirstName:<first name> lastName:<last name> email:<email> phone:<phone> shippingAddress:<VTAddress> billingAddress:<VTAddress>];
```

//Present UI Flow controller

```
VTPaymentViewController *paymentController = [VTPaymentViewController controllerWithCustomer:<VTCustomerDetails> andItems:<array of VTItem>];
[self presentViewController:paymentController animated:YES completion:nil];
```

//Present Only UI Flow for CC payment

```
VTCardListController *vc = [[VTCardListController alloc] initWithCustomerDetails:customerDetails itemDetails:self.itemDetails transactionDetails:transactionDetails];
[vc presentOnViewController:self];
```