# Overview
Midtarns iOS SDK makes it easy to build an excellent payment experience in your iOS app. It provides powerful, customizable to collect your users' payment details.

We also expose the low-level APIs that power those elements to make it easy to build fully custom forms. This guide will take you all the way from integrating our SDK to accepting payments from your users via our payment method that we provide

# Content

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.
3. [Install and configure the SDK](#install-and-configure-sdk)
4. [Integration](#sdk-integration)
5. [Checkout](#sdk-checkout)
	 * [Standard](#sdk-checkout-standard)
	 * [Custom with Options](#sdk-checkout-custom)
	 	- [Customer info](#sdk-checkout-custom-customer-info)
		- [Items info](#sdk-checkout-custom-items-info)
		- [Credit card options](#sdk-checkout-custom-items-cc-options)
		- [Gopay options](#sdk-checkout-custom-items-gopay-options)
		- [Custom expired](#sdk-checkout-custom-expiry)
		- [Custom fields](#sdk-checkout-custom-fields)
6. [Get payment info](#sdk-get-payment-info)
7. [Charge](#sdk-charge)
	- [Bank Transfer](#sdk-charge-bank-transfer)
	- [Direct Debit](#sdk-charge-direct-debit)
		- [Mandiri Clickpay](#sdk-charge-mandiri-clickpay)
		- [CIMB Clicks](#sdk-charge-cimb-clicks)
		- [ePay BRI](#sdk-charge-epay-bri)
		- [BCA KlikPay](#sdk-charge-bca-klikpay)
		- [KlikBCA](#sdk-charge-klikbca)
	- [Convenience Store](#sdk-charge-convenience-store)
		- [Indomaret](#sdk-charge-indomaret)
	- [e-Wallet](#sdk-charge-wallet)
		- [Telkomsel Cash](#sdk-charge-tcash)
		- [Mandiri E-Cash](#sdk-charge-ecash)
		- [Go-Pay](#sdk-charge-gopay)
	- [Card Payment](#sdk-charge-card-payment)
		- Credit Card
	- [Customer Financing](#sdk-charge-customer-financing)
		- Akulaku

## <a id="install-and-configure-sdk"></a> Install and configure the SDK
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

## <a id="sdk-integration"></a> Integration
After you're done installing the SDK, configure it with your Midtrans API keys.


ObjC

``` 
[MIDClient configureClientKey:@"VT-client-ABCDEFG-KM1234"
			merchantServerURL:@"https://merchant-server.com/charge/index.php"
				  environment:MIDEnvironmentSandbox];

```

Swift

``` 
MIDClient.configureClientKey(
    "VT-client-ABCDEFG-KM1234",
    merchantServerURL: "https://merchant-server.com/charge/index.php",
    environment: .sandbox
)

```


## <a id="sdk-checkout"></a> Checkout
**Checkout provides your customers with a streamlined, mobile-ready payment experience.**

Checkout securely accepts your customer's payment details and directly passes them to Midtrans servers. Midtrans returns a token representation of those payment details, which can then be submitted to your server for use.
	
### <a id="sdk-checkout-standard"></a> Standard Checkout

**Order ID**
 
 This value must be unique, you can use it once
 
  `NSString *orderID = @"unique_string";`
 
**Transaction Detail**

This method is called, as you might expect, when the payment context's eg Order id, and gross amount of transaction

Objective C

```
MIDCheckoutTransaction *trx = [[MIDCheckoutTransaction alloc] initWithOrderID:orderID
                                                                  grossAmount:@15000
                                                                     currency:MIDCurrencyIDR];
``` 

Swift

```
let trx = MIDCheckoutTransaction(
    orderID: orderID,
    grossAmount: 15000,
    currency: .IDR
)
``` 



Then you can put it all together to generate the checkout token with this simple method
	
Objective C	

```
[MIDClient checkoutWith:trx
                options:nil
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     NSString *snapToken = token.token;
 }];
```

Swift

```
MIDClient.checkout(with: trx, options: nil) { (token, error) in
	let snapToken = token?.token ?? ""
}
```

### <a id="sdk-checkout-custom"></a> Custom Checkout with Options
This guide covers how to use the individual components of our SDK.

> **This guide assumes you've already followed the Getting Started section of our main tutorial to install and configure our SDK.**

**<a id="sdk-checkout-custom-customer-info"></a>Customer info option**

The `MIDCustomerDetails` class makes it easy to let your apps manage their customer information that will be attached on checkout process.

Objective C

```
MIDAddress *addr = [[MIDAddress alloc] initWithFirstName:@"susan"
                                                lastName:@"bahtiar"
                                                   email:@"susan_bahtiar@gmail.com"
                                                   phone:@"08123456789"
                                                 address:@"Kemayoran"
                                                    city:@"Jakarta"
                                              postalCode:@"10610"
                                             countryCode:@"IDN"];
MIDCustomerDetails *customer = [[MIDCustomerDetails alloc] initWithFirstName:@"susan"
                                                                      lastName:@"bahtiar"
                                                                         email:@"susan_bahtiar@gmail.com"
                                                                         phone:@"08123456789"
                                                                billingAddress:addr
                                                               shippingAddress:addr];
	                                                            
//and put it at checkout options
	                                                            
[MIDClient checkoutWith:trx
                options:@[customer]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
		NSString *snapToken = token.token;   
 }];	                                                            
```

Swift

```
let address = MIDAddress(
    firstName: "susan",
    lastName: "bahtiar",
    email: "susan_bahtiar@gmail.com",
    phone: "085293837657",
    address: "Kemayoran",
    city: "Jakarta",
    postalCode: "10610",
    countryCode: "IDN"
)
let customer = MIDCustomerDetails(
    firstName: "susan",
    lastName: "bahtiar",
    email: "susan_bahtiar@gmail.com",
    phone: "085293837657",
    billingAddress: address,
    shippingAddress: address
)

//and put it at checkout options

MIDClient.checkout(with: trx, options: [customer]) { (token, error) in
	let snapToken = token?.token ?? ""
}

```


**<a id="sdk-checkout-custom-items-info"></a>Items info option**

The `MIDItem ` class makes it easy to let your apps manage the item information that will be attached on checkout process.

Objective C

```
MIDItem *item = [[MIDItem alloc] initWithID:@"item1"
                                      price:@15000
                                   quantity:1
                                       name:@"Tooth paste"
                                      brand:@"Pepsodent"
                                   category:@"Health care"
                               merchantName:@"Neo Store"];
MIDCheckoutItems *checkoutItem = [[MIDCheckoutItems alloc] initWithItems:@[item]];
    
//and put it at checkout options

[MIDClient checkoutWith:trx
                options:@[items]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     NSString *snapToken = token.token;
 }];
```

Swift

```
let item = MIDItem(
    id: "item1",
    price: 15000,
    quantity: 1,
    name: "Tooth paste",
    brand: "Pepsodent",
    category: "health care",
    merchantName: "Neo Store"
)
let checkoutItem = MIDCheckoutItems(items: [item])
    
//and put it at checkout options
    
MIDClient.checkout(with: trx, options: [checkoutItem]) { (token, error) in
	let snapToken = token?.token ?? ""
}
```


**<a id="sdk-checkout-custom-items-cc-options"></a>Credit Card Option**

The`MIDCreditCard` class makes it easy to let your apps manage credit card setting  information that will be attached on checkout process.

Objective C

```
NSArray *whitelistBins = @[@"48111111", @"41111111"];
NSArray *blacklistBins = @[@"49111111", @"44111111"];
MIDInstallmentTerm *term = [[MIDInstallmentTerm alloc] initWithBank:MIDAcquiringBankBCA
                                                                              terms:@[@6, @12]];
MIDInstallment *installment = [[MIDInstallment alloc] initWithTerms:@[term] required:YES];
MIDCreditCard *cc = [[MIDCreditCard alloc] initWithTransactionType:MIDCreditCardTransactionTypeAuthorizeCapture
                                                                      enableSecure:YES
                                                                     acquiringBank:MIDAcquiringBankBCA
                                                                  acquiringChannel:MIDAcquiringChannelMIGS
                                                                       installment:installment
                                                                     whiteListBins:whitelistBins
                                                                     blackListBins:blacklistBins];

//and put it at checkout options

[MIDClient checkoutWith:trx
                options:@[cc]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     NSString *snapToken = token.token;
 }];
```
Swift

```
let whitelistBins = ["48111111", "41111111"]
let blacklistBins = ["49111111", "44111111"]
let term = MIDInstallmentTerm(bank: .BCA, terms: [6, 12])
let installment = MIDInstallment(terms: [term], required: true)
let cc = MIDCreditCard(
    transactionType: .authorizeCapture,
    enableSecure: true,
    acquiringBank: .BCA,
    acquiringChannel: .MIGS,
    installment: installment,
    whiteListBins: whitelistBins,
    blackListBins: blacklistBins
)
    
//and put it at checkout options
    
MIDClient.checkout(with: trx, options: [cc]) { (token, error) in
    let snapToken = token?.token ?? ""
}
```

**<a id="sdk-checkout-custom-items-gopay-options"></a>GO-PAY Option**

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

Set up the checkout option

Objective C

```
MIDCheckoutGoPay *gopay = [[MIDCheckoutGoPay alloc] initWithCallbackSchemeURL:@"yoururlscheme://"];
    
//and put it at checkout options
    
[MIDClient checkoutWith:trx
                options:@[gopay]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
	
 }];
```

Swift

```
let gopay = MIDCheckoutGoPay(callbackSchemeURL: "yoururlscheme://")
        
//and put it at checkout options
    
MIDClient.checkout(with: trx, options: [gopay]) { (token, error) in
    let snapToken = token?.token ?? ""
}
```

**<a id="sdk-checkout-custom-expiry"></a>Custom Expiry Option**

Objective C

```
MIDCheckoutExpiry *expiry = [[MIDCheckoutExpiry alloc] initWithStartDate:[NSDate date]
                                                                duration:1
                                                                    unit:MIDExpiryTimeUnitDay];
    
//and put it at checkout options
    
[MIDClient checkoutWith:trx
                options:@[expiry]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
		NSString *snapToken = token.token;
 }];
```

Swift

```
let customExpiry = MIDCheckoutExpiry(start: Date(), duration: 1, unit: .day)
        
//and put it at checkout options
    
MIDClient.checkout(with: trx, options: [customExpiry]) { (token, error) in
    let snapToken = token?.token ?? ""
}
```

**<a id="sdk-checkout-custom-fields"></a>Custom Fields Option**

```
MIDCustomField *customField = [[MIDCustomField alloc] initWithCustomField1:@"field content 1"
                                                              customField2:@"field content 2"
                                                              customField3:@"field content 3"];

//and put it at checkout options

[MIDClient checkoutWith:trx
                options:@[customField]
             completion:^(MIDToken * _Nullable token, NSError * _Nullable error)
 {
     NSString *snapToken = token.token;
 }];
```

Swift

```
let customField = MIDCustomField(
    customField1: "field content 1",
    customField2: "field content 2",
    customField3: "field content 3"
)
    
//and put it at checkout options
    
MIDClient.checkout(with: trx, options: [customField]) { (token, error) in
    let snapToken = token?.token ?? ""
}
```


## <a id="sdk-get-payment-info"></a> Get Payment Info

Objective C

```
[MIDClient getPaymentInfoWithToken:snapToken
                        completion:^(MIDPaymentInfo * _Nullable info, NSError * _Nullable error)
 {
	
 }];
```

Swift

```
MIDClient.getPaymentInfo(withToken: snapToken, completion: { (info, error) in
    
})
```

## <a id="sdk-charge"></a> Charge

**<a id="sdk-charge-bank-transfer"></a>VA / Bank Transfer**

1. BCA

	Objective C
	
	```
	[MIDBankTransferCharge bcaWithToken:snapToken
                                  email:@"susan_bahtiar@gmail.com"
                             completion:^(MIDBCABankTransferResult * _Nullable result, NSError * _Nullable error)
     {

     }];
	```
	
	Swift
	
	```
	MIDBankTransferCharge.bca(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
    })
	```

2. Permata
	
	Objective C
	
	```
    [MIDBankTransferCharge permataWithToken:snapToken
                                      email:@"susan_bahtiar@gmail.com"
                                 completion:^(MIDPermataBankTransferResult * _Nullable result, NSError * _Nullable error)
    {        

    }];	
	```
	
	Swift
	
	```
	MIDBankTransferCharge.permata(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
         
    })
	```
	
3. BNI

	Objective C
	
	```
 	[MIDBankTransferCharge bniWithToken:snapToken
                                  email:@"susan_bahtiar@gmail.com"
                             completion:^(MIDBNIBankTransferResult * _Nullable result, NSError * _Nullable error)
    {
   
    }];
	```
	
	Swift
	
	```
	MIDBankTransferCharge.bni(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
    })
	```
	
4. Mandiri
	
	Objective C
	
	```
	[MIDBankTransferCharge mandiriWithToken:snapToken
                                      email:@"susan_bahtiar@gmail.com"
                                 completion:^(MIDMandiriBankTransferResult * _Nullable result, NSError * _Nullable error)
    {
		    
    }];
	```
	
	Swift
	
	```
	MIDBankTransferCharge.mandiri(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
        
    })
	```
	
5. Other
	
	Objective C
	
	```
	[MIDBankTransferCharge otherWithToken:token email:@"susan_bahtiar@gmail.com" completion:^(id _Nullable result, NSError * _Nullable error) {
		
    }];
	```
	
	Swift
	
	```
	MIDBankTransferCharge.other(withToken: snapToken, email: "susan_bahtiar@gmail.com", completion: { (result, error) in
                
    })
	```
	
**<a id="sdk-charge-direct-debit"></a>Direct Debit**

1. <a id="sdk-charge-mandiri-clickpay"></a>Mandiri Clickpay

	Objective C
	
	```
    [MIDDirectDebitCharge mandiriClickpayWithToken:snapToken
                                        cardNumber:@"4111111111111111"
                                     clickpayToken:@"000000"
                                        completion:^(MIDClickpayResult * _Nullable result, NSError * _Nullable error)
     {

     }];
	```
	
	Swift
	
	```
	MIDDirectDebitCharge.mandiriClickpay(
        withToken: snapToken,
        cardNumber: "4111111111111111",
        clickpayToken: "000000",
        completion: { (result, error) in
     	      
    })
	```
	

2. <a id="sdk-charge-cimb-clicks"></a>CIMB Clicks

	Objective C
	
	```
    [MIDDirectDebitCharge cimbClicksWithToken:snapToken
                                   completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
     {
         //handle result or error
     }];	
	```
	
	Swift
	
	```
	MIDDirectDebitCharge.cimbClicks(withToken: snapToken, completion: { (result, error) in
                
	})
	```
	
3. <a id="sdk-charge-epay-bri"></a>ePay BRI

	Objective C
	
	```
	[MIDDirectDebitCharge briEpayWithToken:snapToken
                                completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
     {

     }];
	```
	
	Swift
	
	```
	MIDDirectDebitCharge.briEpay(withToken: snapToken, completion: { (result, error) in
                
    })
	```
	
4. <a id="sdk-charge-bca-klikpay"></a>BCA KlikPay

	Objective C
	
	```
	[MIDDirectDebitCharge bcaKlikPayWithToken:snapToken
                                   completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
     {

     }];
	```
	
	Swift
	
	```
	MIDDirectDebitCharge.bcaKlikPay(withToken: snapToken, completion: { (result, error) in
                
	})
	```
	
5. <a id="sdk-charge-klikbca"></a>KlikBCA

	Objective C
	
	```
	[MIDDirectDebitCharge klikbcaWithToken:snapToken
                                    userID:@"SUSAN0707"
                                completion:^(MIDKlikbcaResult * _Nullable result, NSError * _Nullable error)
     {
         //handle result or error
     }];
	```
	
	Swift
	
	```
	MIDDirectDebitCharge.klikbca(withToken: snapToken, userID: "SUSAN0707", completion: { (result, error) in
                
    })
	```
	
**<a id="sdk-charge-convenience-store"></a>Convenience Store**

1. <a id="sdk-charge-indomaret"></a>Indomaret

	Objective C
	
	```
	[MIDStoreCharge indomaretWithToken:snapToken
                            completion:^(MIDIndomaretResult * _Nullable result, NSError * _Nullable error)
     {

     }];
	```
	
	Swift
	
	```
	MIDStoreCharge.indomaret(withToken: snapToken, completion: { (result, error) in
                
    })
	```
	
**<a id="sdk-charge-wallet"></a>E-Wallet**

1. <a id="sdk-charge-gopay"></a>Go-Pay

	Objective C
	
	```
    [MIDEWalletCharge gopayWithToken:snapToken
                          completion:^(MIDGopayResult * _Nullable result, NSError * _Nullable error)
     {
         //handle result or error
     }];
	```
	
	Swift
	
	```
	MIDEWalletCharge.gopay(withToken: snapToken, completion: { (result, error) in
                
    })
	```

2. <a id="sdk-charge-tcash"></a>Telkomsel Cash

	Objective C
	
	```
    [MIDEWalletCharge tcashWithToken:snapToken
                         phoneNumber:@"0811111111"
                          completion:^(MIDPaymentResult * _Nullable result, NSError * _Nullable error)
     {

     }];	
	```
	
	Swift
	
	```
	MIDEWalletCharge.tcash(withToken: snapToken, phoneNumber: "0811111111", completion: { (result, error) in
                
    })
	```
	
3. <a id="sdk-charge-ecash"></a>Mandiri e-Cash

	Objective C
	
	```
	[MIDEWalletCharge mandiriECashWithToken:token
	                             completion:^(MIDWebPaymentResult * _Nullable result, NSError * _Nullable error)
	 {
	     //handle result or error
	 }];

	```

	Swift
	
	```
	MIDEWalletCharge.mandiriECash(withToken: snapToken, completion: { (result, error) in
                
    })
	```