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
    pod 'MidtransCoreKit'
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

Once you have completed installation of MidtransKit, configure it with your `clientKey` and `environment` in your `AppDelegate.h`

```
//AppDelegate.m
#import <MidtransKit/MidtransKit.h>

[MidtransConfig setClientKey:@"your_client_key" andServerEnvironment:server_environment];
```

# Payment

##### Generate `TransactionTokenResponse` object

To create this object, you need to prepare required objects like `MidtransItemDetail` as an item representation etc.

```
//ViewController.m
MidtransItemDetail *itemDetail = [[MidtransItemDetail alloc] initWithItemID:@"item_id"
                                                           name:@"item_name"
                                                          price:item_price
                                                       quantity:item_quantiry];

MidtransCustomerDetails *customerDetails = [[MidtransCustomerDetails alloc] initWithFirstName:@"user_firstname"
    										                                    lastName:@"user_lastname"
    										                                       email:@"user_email"
    										                                       phone:@"user_phone"
    										                             shippingAddress:ship_address
    										                              billingAddress:bill_address];

MidtransTransactionDetails *transactionDetails = [[MidtransTransactionDetails alloc] initWithOrderID:@"order_id"
                                                                          andGrossAmount:items_gross_amount];

NSURL *merchantURL = [NSURL URLWithString:@"merchant-url-for-generating-token"];
[[MidtransMerchantClient sharedClient] requestTransactionTokenWithclientTokenURL:merchantURL
                                                        transactionDetails:transactionDetails
                                                               itemDetails:@[itemDetail]
                                                           customerDetails:customerDetails
                                                                completion:^(TransactionTokenResponse *token, NSError * error)
 {
     if (token) {
         //present token
     } else {
     	  //generate token error       
     }
 }];
```

##### Present the `MidtransUIPaymentViewController`

We provide you a `MidtransUIPaymentViewController` to handle all the payment, it's basically a `UINavigtionViewController` so you need to use `presentViewController:_ animated:_ completion:_` to present it.

```
MidtransUIPaymentViewController *vc = [[MidtransUIPaymentViewController alloc] initWithToken:token];
[self presentViewController:vc animated:YES completion:nil];
```

# Get Notified

Set your view controller to conform with **MidtransUIPaymentViewControllerDelegate**

```
//ViewController.m

#import <MidtransKit/MidtransKit.h>

@interface ViewController () <MidtransUIPaymentViewControllerDelegate>
//other code
```

Set the delegate of MidtransUIPaymentViewController

```
//ViewController.m

MidtransUIPaymentViewController *vc = [[MidtransUIPaymentViewController alloc] initWithToken:token];
//set the delegate
vc.delegate = self;
```

Add two methods to your view controller, these methods are from MidtransUIPaymentViewControllerDelegate protocol

```
//ViewController.m

#pragma mark - MidtransUIPaymentViewControllerDelegate

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(VTTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"error: %@", error);
}
```

# Customise Theme Color & Font

We've created `MidtransUIThemeManager` to configure the theme color and font of the veritrans payment UI.

```
MidtransUIFontSource fontSource = [[MidtransUIFontSource alloc] initWithFontNameBold:font_name
												             fontNameRegular:font_name
												               fontNameLight:font_name];
[MidtransUIThemeManager applyCustomThemeColor:themeColor themeFont:fontSource];
```
Put this code before you present the `MidtransUIPaymentViewController`
