# Setup

[![Join the chat at https://gitter.im/veritrans/Veritrans-ios-sdk](https://badges.gitter.im/veritrans/Veritrans-ios-sdk.svg)](https://gitter.im/veritrans/Veritrans-ios-sdk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
    pod 'MidtransCoreKit'
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

Copy and paste the following code into `application:didFinishLaunchingWithOptions:` in your `AppDelegate`

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

### Configure features for credit card payment

#### Two Click & One Click
`Two Click` and `One Click` are feature for simplify credit card payment. You can read more detail [here](http://docs.veritrans.co.id/en/vtdirect/other_features.html).

Copy and paste the following code wherever you think is good as long as it's executed before you present the `VTPaymentViewController`.

```
[[VTCardControllerConfig sharedInstance] setEnableOneClick:YES];
```

You can configure it with `VTCardControllerConfig`, if it's not configure it will automatically use `Two Click` feature

#### 3D Secure
3-D Secure is an authenticated payment system to improve online transaction security

Copy and paste the following code wherever you think is good as long as it's executed before you present the `VTPaymentViewController`.

```
[[VTCardControllerConfig sharedInstance] setEnable3DSecure:YES];
```
If it's not configure, the default value is `NO`.

# Get Notified

Set your view controller to conform with **VTPaymentViewControllerDelegate**

```
#import "ViewController.h"
#import <MidtransKit/MidtransKit.h>

@interface ViewController () <VTPaymentViewControllerDelegate>

@end

```

Set the delegate of VTPaymentViewController 

```
VTPaymentViewController *vc = [[VTPaymentViewController alloc] initWithCustomerDetails:customerDetails itemDetails:self.itemDetails transactionDetails:transactionDetails];
//set the delegate
vc.delegate = self;
```

Add two methods to your view controller, these methods are from VTPaymentViewControllerDelegate protocol

```
#pragma mark - VTPaymentViewControllerDelegate

- (void)paymentViewController:(VTPaymentViewController *)viewController paymentSuccess:(VTTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(VTPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"error: %@", error);
}
```
