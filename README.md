# Setup

### Requirement

[Cococapods](https://cocoapods.org/) version 1.0.0

### Installation
Navigate to your project's root directory and run `pod init` to create a `Podfile`. 

```
pod init
```

Open up the `Podfile` and add `MidtransKit` to your project's target.

```
platform :ios, '7.0'

def shared_pods
    pod 'MidtransKit'
end

target 'MyBeautifulApp' do
    shared_pods
end
```

Save the file and run the following to install `MidtransKit`.

```
pod install --verbose
```

Cocoapods will download and install `MidtransKit` and also create a .xcworkspace project.

# Integration

Once you have completed installation of MidtransKit, import the MidtransKit headers into your `AppDelegate.h`

```
#import <MidtransKit/MidtransKit.h>
```

Copy and paste the following into `application:didFinishLaunchingWithOptions:` in your `AppDelegate`

```
[VTConfig setClientKey:<#(NSString *)#> 
     merchantServerURL:<#(NSString *)#> 
     serverEnvironment:<#(VTServerEnvironment)#> 
    merchantClientData:<#(id)#>];
```

The SDK doesn't do any processing to `merchantClientData`. The SDK will just pass the content of `merchantClientData` via HTTP header whenever the SDK needs to do network call to Merchant Server. So, the SDK implementor is responsible for the content of the `merchantClientData`.

# Payment 

You can easly do the transaction with `MidtransKit` by presenting the `VTPaymentViewController`. 

Copy and paste the following code in to your `ViewController` that ready to present `VTPaymentViewController`

```
// itemDetail is an item for sale
VTItemDetail *itemDetail = [[VTItemDetail alloc] initWithItemID:<#(NSString *)#> name:<#(NSString *)#> price:<#(NSNumber *)#> quantity:<#(NSNumber *)#>];

// customerDetails is customer object 
VTCustomerDetails *customerDetails = [[VTCustomerDetails alloc] initWithFirstName:<#(NSString *)#> lastName:<#(NSString *)#> email:<#(NSString *)#> phone:<#(NSString *)#> shippingAddress:<#(VTAddress *)#> billingAddress:<#(VTAddress *)#>];

// transactionDetails is the detail of transaction including the orderID and gross amount
VTTransactionDetails *transactionDetails = [[VTTransactionDetails alloc] initWithOrderID:<#(NSString *)#> andGrossAmount:<#(NSNumber *)#>];

// create object VTPaymentViewController and present it
VTPaymentViewController *vc = [[VTPaymentViewController alloc] initWithCustomerDetails:customerDetails itemDetails:@[itemDetail] transactionDetails:transactionDetails];
        [self presentViewController:vc animated:YES completion:nil];
```