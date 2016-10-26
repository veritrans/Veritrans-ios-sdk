### Overview
We provide an API-only implementation for all payment types. This allows users to bring your own UI to the mobile App. Please read [this section](https://github.com/veritrans/Veritrans-ios-sdk/wiki/Getting-started-with-the-Veritrans-SDK) first before walking through the implementation guide

### Prerequsites

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.

### Supported Payments
1. Credit Card
2. Telkomsel Cash
3. XL Tunai
4. Indosat Dompetku
5. VA / Bank Transfer
6. CIMB Clicks
7. Indomaret
8. BCA KlikPay
9. Klikbca
10. Mandiri E-Cash
11. Mandiri Clickpay
12. BRI E-Pay
13. Kios ON

### Setup

#### Requirement

[Cococapods](https://cocoapods.org/) version 1.0.0

#### Installation
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

#### Integration

Once you have completed installation of MidtransKit, configure it with your `clientKey` and `environment` in your `AppDelegate.h`

```
//AppDelegate.m
#import <MidtransKit/MidtransKit.h>

[MidtransConfig setClientKey:@"your_client_key" andServerEnvironment:server_environment];
```

#### Generate Transaction Token

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
[[MidtransMerchantClient shared] requestTransactionTokenWithclientTokenURL:merchantURL
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

### 1. Credit Card

In Credit Card transaction there are two main steps to make transaction

* Generate `card_token` as representation of credit card
* Charge transaction with generated and valid `card_token`


#### 1.1 Generate Card Token

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

[[MidtransClient shared] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
    if (error) {
        //handle error
    } else {
        //use the card token
    }
}];

```

#### 1.2 <a name="charge-normal-transaction"></a>Charge Transaction
After you have a valid `card_token`, you can continue to the final step of payment and your credit card will be charged.

Use following code as a template.

```
MidtransPaymentCreditCard *paymentDetail = [[MidtransPaymentCreditCard alloc] initWithCreditCardToken:card_token customerDetails:transaction_token.customerDetails];

//set this if you want to save card
paymentDetail.saveToken = self.view.saveCardSwitch.on;

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:transaction_token];
```

You will have `result` if the transaction is success, and `error` if the transaction is failed.

### 2. Telkomsel Cash
```
MidtransPaymentTelkomselCash *paymentDetails = [[MidtransPaymentTelkomselCash alloc] initWithMSISDN:<phone number>];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //handle success result
    }
}];
```

### 3. XL Tunai
```
MidtransPaymentXLTunai *paymentDetails = [[MidtransPaymentXLTunai alloc] init];
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        if (result.redirectURL) {
              //transaction need to continue via webcontainer
            MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result paymentIdentifier:@"xl_tunai"];
            vc.delegate = self;
            //present the web container
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}];
```

### 4. Indosat Dompetku
```
MidtransPaymentIndosatDompetku *paymentDetails = [[MidtransPaymentIndosatDompetku alloc] initWithMSISDN:<phone number>];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //handle success result
    }
}];
```

### 5. VA / Bank Transfer

#### 5.1 Preparing Payment Details
You need to create `paymentDetail` as object of **MidtransPaymentBankTransfer** and set the bank transfer type with **MidtransVAType** values

* MidtransVATypeBCA
* MidtransVATypeMandiri
* MidtransVATypePermata
* MidtransVATypeOther

```
MidtransPaymentBankTransfer *paymentDetails = paymentDetails = [[MidtransPaymentBankTransfer alloc] initWithBankTransferType:<va type> email:<email>];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails];
```

#### 5.2 Handle Transaction Result
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

### 6. CIMB Clicks
```
MidtransPaymentCIMBClicks *paymentDetails = [[MidtransPaymentCIMBClicks alloc] init];
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        if (result.redirectURL) {
              //transaction need to continue via webcontainer
            MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result paymentIdentifier:@"cimb_clicks"];
            vc.delegate = self;
            //present the web container
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}];
```

### 7. Indomaret
```
MidtransPaymentCStore *paymentDetails = [[MidtransPaymentCStore alloc] init];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

### 8. BCA KlikPay
```
MidtransPaymentBCAKlikpay *paymentDetails = [[MidtransPaymentBCAKlikpay alloc] init];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        if (result.redirectURL) {
              //transaction need to continue via webcontainer
            MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result paymentIdentifier:@"bca_klikpay"];
            vc.delegate = self;
            //present the web container
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}];
```

### 9. KlikBCA
```
MidtransPaymentKlikBCA *paymentDetails = [[MidtransPaymentKlikBCA alloc] initWithKlikBCAUserId:<klikbca userid>];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

### 10. Mandiri E-Cash
```
MidtransPaymentMandiriECash *paymentDetails = [[MidtransPaymentMandiriECash alloc] init];
MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        if (result.redirectURL) {
            //transaction need to continue via webcontainer
            MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result paymentIdentifier:@"mandiri_ecash"];
            vc.delegate = self;
            //present the web container
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}];
```

### 11. Mandiri Clickpay
```
MidtransPaymentMandiriClickpay *paymentDetails = [[MidtransPaymentMandiriClickpay alloc] initWithCardNumber:<clickpay number> clickpayToken:<clickpay token>];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //transaction success
    }
}];
```

### 12. BRI E-Pay

```
MidtransPaymentEpayBRI *paymentDetails = [[MidtransPaymentEpayBRI alloc] init];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        if (result.redirectURL) {
            //transaction need to continue via webcontainer
            MidtransPaymentWebController *vc = [[MidtransPaymentWebController alloc] initWithTransactionResult:result paymentIdentifier:@"bri_epay"];
            vc.delegate = self;
            //present the web container
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}];
```

### 13. Kioson

```
MidtransPaymentKiosOn *paymentDetails = [[MidtransPaymentKiosOn alloc] init];

MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetails token:transaction_token];

[[MidtransMerchantClient shared] performTransaction:transaction completion:^(MidtransTransactionResult *result, NSError *error) {
    if (error) {
        //handle error
    } else {
        //handle success result
    }
}];
```
