### Overview
Midtarns iOS SDK makes it easy to build an excellent payment experience in your iOS app. It provides powerful, customizable to collect your users' payment details.

We also expose the low-level APIs that power those elements to make it easy to build fully custom forms. This guide will take you all the way from integrating our SDK to accepting payments from your users via our payment method that we provide

### Prerequsites

- Create a merchant account in MAP
- Setup your merchant accounts settings, in particular Notification URL.
- [Install and configure the SDK](#install-and-configure-sdk)
- [Integration](#sdk-integration)
- [Checkout](#sdk-checkout)
- [Standard](#sdk-checkout-standard)
- [Custom with Options](#sdk-checkout-custom)
	- [Customer info](#sdk-checkout-custom-customer-info)
	- [Items info](#sdk-checkout-custom-items-info)
   	- [Credit card options](#sdk-checkout-custom-items-cc-options)
   	- [Gopay options](#sdk-checkout-custom-items-gopay-options)
   	- Custom expired
   	- Custom fields
 - [Get payment info](#sdk-get-payment-info)
 - [Charge](#sdk-charge)
 	- Credit Card
	- [VA / Bank Transfer](#sdk-charge-bank-transfer)
	- CIMB Clicks
	- Indomaret
	- BCA KlikPay
	- Klikbca
	- Mandiri E-Cash
	- Mandiri Clickpay
	- BRI E-Pay
	- Kios ON
	- Akulaku

### Supported Payments
1. Credit Card
2. VA / Bank Transfer
3. CIMB Clicks
4. Indomaret
5. BCA KlikPay
6. Klikbca
7. Mandiri E-Cash
8. Mandiri Clickpay
9. BRI E-Pay
10. Kios ON
11. Akulaku


#### <a id="install-and-configure-sdk"></a> Install and configure the SDK
You can choose to install the Midtrans iOS SDK via your favorite method. We support CocoaPods and manual installation with both static and dynamic frameworks.

1. If you haven't already, install the latest version of [Cococapods](https://cocoapods.org/).
2. Add this line to your Podfile:


	```
	platform :ios, '7.0'

	def shared_pods
	pod 'MidtransCoreKit'
	end

	target 'MyBeautifulApp' do
	shared_pods
	end
	```
3. Run the following command:

	```
	pod install

	```
4. Don't forget to use the .xcworkspace file to open your project in Xcode, instead of the .xcodeproj file, from here on out.
5. In the future, to update to the latest version of the SDK, just run:

	```
	pod update MidtransCoreKit
	```

#### <a id="sdk-integration"></a> Integration
After you're done installing the SDK, configure it with your Midtrans API keys.



```
#import "AppDelegate"
#import <Midtrans/MidtransCoreKit.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[MIDClient configureClientKey:`client_key`
				merchantServerURL:`merchant url`
					  environment:'environment'];
					  
	return YES;
}

@end

```
#### <a id="sdk-checkout"></a> Checkout
**Checkout provides your customers with a streamlined, mobile-ready payment experience.**

Checkout securely accepts your customer's payment details and directly passes them to Midtrans servers. Midtrans returns a token representation of those payment details, which can then be submitted to your server for use.
	
###<a id="sdk-checkout-standard"></a> Standard

Our SDK provides a class called `MIDClient`, which is designed to make building your app's checkout flow as easy as possible. It handles payment options such as payment chanels, customer information and can also be used to collect shipping info.

**Setting checkout and host view controller**

To work with Midtrans Checkout, you'll need to write a class that conforms to STPPaymentContextDelegate. (Note, the code samples in this section are simply examples – your own implementation may differ depending on the structure of your app). Midtrans Checkout has 3 required parameters:

 **Order ID**
 
 This value must be unique, you can use it once
 
  `NSString *orderID = @"some order id";`
 
**Transaction Detail**

This method is called, as you might expect, when the payment context's eg Order id, and gross amount of transaction

```
NSString *orderID = <random string>
MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID
                                                                  grossAmount:@1000];
``` 



Then you can put it all together to generate the checkout token with this simple method
	
```
[MIDClient checkoutWith:trx
                options:nil
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     
 }];
```

### <a id="sdk-checkout-custom"></a> Custom with Options
This guide covers how to use the individual components of our SDK.

> **This guide assumes you've already followed the Getting Started section of our main tutorial to install and configure our SDK.**

**<a id="sdk-checkout-custom-customer-info"></a>Customer info**

The `MIDCheckoutCustomer` class makes it easy to let your apps manage their customer information that will be attached on checkout process.

```
 MIDCheckoutCustomer *customer = [[MIDCheckoutCustomer alloc] initWithFirstName:@"Customer Firstname"
                                                                         lastName:@"Customer Last Name"
                                                                            email:@"customer@somemail.com"
                                                                            phone:@"00000000"
                                                                   billingAddress:nil
                                                                  shippingAddress:nil];
```

and put it when do checkout

```
[MIDClient checkoutWith:<MIDCheckoutTransaction>
                options:@[customer]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     
 }];
```

**<a id="sdk-checkout-custom-items-info"></a>Items info**

The `MIDItem ` class makes it easy to let your apps manage the item information that will be attached on checkout process.

```
MIDItem *items = [[MIDItem alloc] initWithID:@"items id"
                                       price:2000
                                    quantity:1
                                        name:@"Item Name"
                                       brand:@"Brand"
                                    category:@"Some Category"
                                merchantName:@"Merchant Name"];
```

and put it when do checkout

```
[MIDClient checkoutWith:<MIDCheckoutTransaction>
                options:@[items]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     
 }];
```


**<a id="sdk-checkout-custom-items-cc-options"></a>Credit Card Options**

The`MIDCheckoutCreditCard ` class makes it easy to let your apps manage credit card setting  information that will be attached on checkout process.

```
MIDCheckoutCreditCard *creditCardOptions = [[MIDCheckoutCreditCard alloc] initWithTransactionType:MIDCreditCardTransactionTypeAuthorizeCapture
                                                                      enableSecure:NO
                                                                    enableSaveCard:NO
                                                                     acquiringBank:MIDAcquiringBankNone
                                                                  acquiringChannel:MIDAcquiringChannelNone
                                                                       installment:nil
                                                                     whiteListBins:nil];
```

and put it when do checkout

```
[MIDClient checkoutWith:<MIDCheckoutTransaction>
                options:@[creditCardOptions]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     
 }];
```
**<a id="sdk-checkout-custom-items-gopay-options"></a>GO-PAY Options**

The`MIDCheckoutGoPay ` class makes it easy to let your apps manage GO-PAY callback that will be attached on checkout process, but first you need to define your host app deeplink that make sure your apps will called back after transaction has been process by GO-JEK apps

```
<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>None</string>
			<key>CFBundleURLName</key>
			<string>com.midtrans.demo</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>yourapps.prefix</string>
			</array>
		</dict>
	</array>
```

Set up the option

```
MIDCheckoutGoPay *gopay = [[MIDCheckoutGoPay alloc] initWithCallbackSchemeURL:@"yourapps.prefix"];
```

and put it when do checkout

```
[MIDClient checkoutWith:<MIDCheckoutTransaction>
                options:@[gopay]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     
 }];
```

### <a id="sdk-get-payment-info"></a> Get Payment Info

### <a id="sdk-charge"></a> Charge

**<a id="sdk-charge-bank-transfer"></a>VA / Bank Transfer**

1. BCA

	```
	[MIDBankTransferCharge bcaWithToken:<snap token>
                                  email:<email>
                             completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
     {
         
         //handle result or error

     }];
	```

2. Permata

	```
    [MIDBankTransferCharge permataWithToken:<snap token>
                                      email:<email>
                                 completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error)
    {
        
        //handle result or error

    }];	
	```
	
3. BNI

	```
 	[MIDBankTransferCharge bniWithToken:<snap token>
                                  email:<email>
                             completion:^(MIDBNIBankTransferResult * _Nullable result, NSError * _Nullable error)
    {
        
        //handle result or error

    }];
	```
	
4. Mandiri

	```
	[MIDBankTransferCharge mandiriWithToken:<snap token>
                                      email:<email>
                                 completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
    {
        
        //handle result or error
                                    
    }];
	```
