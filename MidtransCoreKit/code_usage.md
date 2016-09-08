
# Overview
We provide an API-only implementation for all payment types, This allows users to bring your own UI to the mobile App.

# Prerequsites

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.

# Supported Payments
1. Credit Card
2. Bank Transfer
3. CIMB Clicks
4. Indomaret
5. BCA KlikPay
6. KlikBCA
7. Mandiri E-Cash
8. Mandiri Clickpay
9. BRI E-Pay

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

# Generate Transaction Token

Before you can do the payment, you need to generate a `transaction_token` as representation of you credentials data.

```
//ViewController.m

MidtransTransactionDetails *transactionDetails =
[[MidtransTransactionDetails alloc] initWithOrderID:@"random_string"
                               andGrossAmount:gross_amount];
                               
MidtransItemDetail *itemDetail =
[[MidtransItemDetail alloc] initWithItemID:@"your_item_id"
                                name:@"item_name"
                               price:item_price
                            quantity:item_qty];
NSArray *itemDetails = @[itemDetail];

MidtransCustomerDetails *customerDetails =
[[MidtransCustomerDetails alloc] initWithFirstName:@"first_name"
                                    lastName:@"last_name"
                                       email:@"email"
                                       phone:@"phone_number"
                             shippingAddress:shipping_address
                              billingAddress:billing_address]
                              
NSURL *merchantURL = [NSURL URLWithString:@"merchant-url"];
[[MidtransMerchantClient sharedClient] requestTransactionTokenWithclientTokenURL:merchantURL
                                                        transactionDetails:transactionDetails
                                                               itemDetails:itemDetails
                                                           customerDetails:customerDetails
                                                                completion:^(TransactionTokenResponse *token, NSError * error)
 {
     if (token) {
         //use this transaction token
     } else {
         //handle error
     }
 }];
```

## 2. Credit Card

In Credit Card transaction there are two main steps to make transaction

* Generate `card_token` as representation of credit card
* Charge transaction with generated and valid `card_token`


### 2.1 Generate Card Token

Use following code as a template

```
MidtransCreditCard *card =
[[MidtransCreditCard alloc] initWithNumber:@"card_number"
                         expiryMonth:@"card_expiry_month"
                          expiryYear:@"card_expiry_year"
                                 cvv:card_cvv];
                                 
//Set 3D secure enable or not by set the secure parameter
BOOL enable3DSecure = YES;

MidtransTokenizeRequest *tokenRequest =
[[MidtransTokenizeRequest alloc] initWithCreditCard:card
                                  grossAmount:transactionDetails.grossAmount
                                       secure:enable3DSecure];

[[MidtransClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
    if (error) {
    	//handle error
    } else {
    	//use the card token 
    }
}];
                                       
```

### 2.2 <a name="charge-normal-transaction"></a>Charge Transaction
After you have a valid `card_token`, you can continue to the final step of payment and your credit card will be charged. 

Use following code as a template.

```
MidtransPaymentCreditCard *paymentDetail = [[MidtransPaymentCreditCard alloc] initWithCreditCardToken:card_token token:transaction_token];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail];

[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

You will have `result` if the transaction is success, and `error` if the transaction is failed.

## 5. VA / Bank Transfer

### 5.1 Preparing Payment Details
You need to create `paymentDetail` as object of **MidtransPaymentBankTransfer** and set the bank transfer type with **MidtransVAType** values

* MidtransVATypeBCA
* MidtransVATypeMandiri
* MidtransVATypePermata
* MidtransVATypeOther

```
MidtransPaymentBankTransfer *paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:<va_type>
                                                                                                  token:transaction_token
                                                                                                  email:@"email"];
                                                                                                  
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    //handle transaction result
}];
```

### 5.2 Handle Transaction Result
After **charge transaction** was successful, you'll get `MidtransTransactionResult` object, which have **codes** that needed to continue the transaction via ATM etc.

```
if (result) {
	<for Mandiri VA>
	NSString *billpayCode = transactionResult.mandiriBillpayCode;
	NSString *companyCode = transactionResult.mandiriBillpayCompanyCode;
	
	<for Others VA>
	NSString *virtualAccountNumber = transactionResult.virtualAccountNumber;
} else {
	//error
}
```

## 6. CIMB Clicks
```
MidtransPaymentCIMBClicks *paymentDetails = [[MidtransPaymentCIMBClicks alloc] initWithToken:transaction_token];
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {    
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 7. Indomaret
```
MidtransPaymentCStore *paymentDetails = [[MidtransPaymentCStore alloc] initWithToken:transaction_token];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 8. BCA KlikPay
```
MidtransPaymentBCAKlikpay *paymentDetails = [[MidtransPaymentBCAKlikpay alloc] initWithToken:transaction_token];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];

[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 9. KlikBCA
```
MidtransPaymentKlikBCA *paymentDetails = [[MidtransPaymentKlikBCA alloc] initWithKlikBCAUserId:@"klikbca_userid"
                                                                                     token:transaction_token];
        
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 10. Mandiri E-Cash
```
MidtransPaymentMandiriECash *paymentDetails = [[MidtransPaymentMandiriECash alloc] initWithToken:transaction_token];
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 11. Mandiri Clickpay
```
MidtransPaymentMandiriClickpay *paymentDetails = [[MidtransPaymentMandiriClickpay alloc] initWithCardNumber:@"debit_number"
                                                                                      clickpayToken:@"token_number"
                                                                                              token:transaction_token];
    
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 12. BRI E-Pay

```
MidtransPaymentEpayBRI *paymentDetails = [[MidtransPaymentEpayBRI alloc] initWithToken:transaction_token];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[MidtransMerchantClient sharedClient] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```
