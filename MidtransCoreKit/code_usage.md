
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

# Generate Transaction Token

Before you can do the payment, you need to generate a `transaction_token` as representation of you credentials data.

```
//ViewController.m

VTTransactionDetails *transactionDetails =
[[VTTransactionDetails alloc] initWithOrderID:@"random_string"
                               andGrossAmount:gross_amount];
                               
VTItemDetail *itemDetail =
[[VTItemDetail alloc] initWithItemID:@"your_item_id"
                                name:@"item_name"
                               price:item_price
                            quantity:item_qty];
NSArray *itemDetails = @[itemDetail];

VTCustomerDetails *customerDetails =
[[VTCustomerDetails alloc] initWithFirstName:@"first_name"
                                    lastName:@"last_name"
                                       email:@"email"
                                       phone:@"phone_number"
                             shippingAddress:shipping_address
                              billingAddress:billing_address]
                              
NSURL *merchantURL = [NSURL URLWithString:@"merchant-url"];
[[VTMerchantClient sharedClient] requestTransactionTokenWithclientTokenURL:merchantURL
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
VTCreditCard *card =
[[VTCreditCard alloc] initWithNumber:@"card_number"
                         expiryMonth:@"card_expiry_month"
                          expiryYear:@"card_expiry_year"
                                 cvv:card_cvv];
                                 
//Set 3D secure enable or not by set the secure parameter
BOOL enable3DSecure = YES;

VTTokenizeRequest *tokenRequest =
[[VTTokenizeRequest alloc] initWithCreditCard:card
                                  grossAmount:transactionDetails.grossAmount
                                       secure:enable3DSecure];

[[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
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
VTPaymentCreditCard *paymentDetail = [[VTPaymentCreditCard alloc] initWithCreditCardToken:card_token token:transaction_token];

VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetail];

[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
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
You need to create `paymentDetail` as object of **VTPaymentBankTransfer** and set the bank transfer type with **VTVAType** values

* VTVATypeBCA
* VTVATypeMandiri
* VTVATypePermata
* VTVATypeOther

```
VTPaymentBankTransfer *paymentDetails = [[VTPaymentBankTransfer alloc] initWithBankTransferType:<va_type>
                                                                                                  token:transaction_token
                                                                                                  email:@"email"];
                                                                                                  
VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    //handle transaction result
}];
```

### 5.2 Handle Transaction Result
After **charge transaction** was successful, you'll get `VTTransactionResult` object, which have **codes** that needed to continue the transaction via ATM etc.

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
VTPaymentCIMBClicks *paymentDetails = [[VTPaymentCIMBClicks alloc] initWithToken:transaction_token];
VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {    
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 7. Indomaret
```
VTPaymentCStore *paymentDetails = [[VTPaymentCStore alloc] initWithToken:transaction_token];

VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 8. BCA KlikPay
```
VTPaymentBCAKlikpay *paymentDetails = [[VTPaymentBCAKlikpay alloc] initWithToken:transaction_token];

VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];

[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 9. KlikBCA
```
VTPaymentKlikBCA *paymentDetails = [[VTPaymentKlikBCA alloc] initWithKlikBCAUserId:@"klikbca_userid"
                                                                                     token:transaction_token];
        
VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 10. Mandiri E-Cash
```
VTPaymentMandiriECash *paymentDetails = [[VTPaymentMandiriECash alloc] initWithToken:transaction_token];
VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 11. Mandiri Clickpay
```
VTPaymentMandiriClickpay *paymentDetails = [[VTPaymentMandiriClickpay alloc] initWithCardNumber:@"debit_number"
                                                                                      clickpayToken:@"token_number"
                                                                                              token:transaction_token];
    
VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

## 12. BRI E-Pay

```
VTPaymentEpayBRI *paymentDetails = [[VTPaymentEpayBRI alloc] initWithToken:transaction_token];

VTTransaction *transaction = [[VTTransaction alloc] initWithPaymentDetails:paymentDetails];
    
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```