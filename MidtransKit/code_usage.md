### Setup
Please read [this section](https://github.com/veritrans/Veritrans-ios-sdk/wiki/Getting-started-with-the-Veritrans-SDK) first before walking through the implementation guide

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

If you want to support [CardIO](https://www.card.io/), update the `Podfile` to this

```
platform :ios, '7.0'

def shared_pods
	pod 'MidtransKit'
	pod 'MidtransKit/CardIO'
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

### Integration

Once you have completed installation of MidtransKit, configure it with your `clientKey` and `environment` in your `AppDelegate.h`

```
//AppDelegate.m
#import <MidtransKit/MidtransKit.h>

[MidtransConfig setClientKey:@"your_client_key" andServerEnvironment:server_environment];
```

### Credit Card Payment Feature
#### 2-Clicks
```
[MidtransCreditCardConfig setPaymentType:MTCreditCardPaymentTypeTwoclick secure:YES];
[MidtransCreditCardConfig disableTokenStorage:YES];
```
Parameter `secure` is for enabling 3D secure transaction, but for 2-clicks, actually it's forced to `true` even if you set it to `false`.

You cannot use `tokenStorage` feature for 2-Click, so disable it and make sure that you're already setup your merchant server to support **save card**. You can see the documentation [here.](https://github.com/veritrans/veritrans-android/wiki/Implementation-for-Merchant-Server)


#### 1-Click

```
[MidtransCreditCardConfig setPaymentType:MTCreditCardPaymentTypeOneclick secure:<Boolean>];
[MidtransCreditCardConfig disableTokenStorage:NO];
```
Parameter `secure` is for enabling 3D secure transaction, and you need to enable `Token Storage` feature. 

### Payment

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

[[MidtransMerchantClient shared] requestTransactionTokenWithTransactionDetails:transactionDetails
                                                                           itemDetails:self.itemDetails
                                                                       customerDetails:customerDetails
                                                                            completion:^(MidtransTransactionTokenResponse * _Nullable token, NSError * _Nullable error)
         {
     if (token) {
     
     }
     else {
     
     }
 }];
```
##### Using Time Limit on transaction
we provide method to handle transaction limitation time, to set it you just need  following this code
```
- (void)requestTransactionTokenWithTransactionDetails:(nonnull MidtransTransactionDetails *)transactionDetails
                                          itemDetails:(nullable NSArray<MidtransItemDetail*> *)itemDetails
                                      customerDetails:(nullable MidtransCustomerDetails *)customerDetails
                                          customField:(nullable NSDictionary *)customField
                                transactionExpireTime:(nullable MidtransTransactionExpire *)expireTime
                                           completion:(void (^_Nullable)(MidtransTransactionTokenResponse *_Nullable token, NSError *_Nullable error))completion;
```

##### Present the `MidtransUIPaymentViewController`

We provide you a `MidtransUIPaymentViewController` to handle all the payment, it's basically a `UINavigtionViewController` so you need to use `presentViewController:_ animated:_ completion:_` to present it.

```
MidtransUIPaymentViewController *vc = [[MidtransUIPaymentViewController alloc] initWithToken:token];
[self presentViewController:vc animated:YES completion:nil];
```

### Get Notified

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

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    [self showAlertError:error];
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSLog(@"pending: %@", result);
}

- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    NSLog(@"canceled");
}
```

### Customise Theme Color & Font

We've created `MidtransUIThemeManager` to configure the theme color and font of the veritrans payment UI.

```
MidtransUIFontSource fontSource = [[MidtransUIFontSource alloc] initWithFontNameBold:font_name
                                                             fontNameRegular:font_name
                                                               fontNameLight:font_name];
[MidtransUIThemeManager applyCustomThemeColor:themeColor themeFont:fontSource];
```
Put this code before you present the `MidtransUIPaymentViewController`
