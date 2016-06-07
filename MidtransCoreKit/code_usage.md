
# Overview
We provide an API-only implementation for all payment types, This allows users to bring your own UI to the mobile App.

# Prerequsites

1. Create a merchant account in MAP
2. Setup your merchant accounts settings, in particular Notification URL.

# Supported Payments
1. Credit Card
2. Bank Transfer

# Other Features
1. Register Card

# Transactions

<!--Credit Card payment is a little bit different with other payments. It need to communicate with `Veritrans Payment API` to Generate `token`.

Credit Card have 3 types of transactions :

* Normal Transaction
* One Click Transaction
* Two Click Transaction
-->
## 1. Requirement
To Create a credit card transaction you need the following objects :

* **VTCustomerDetails**
* Array of **VTItemDetail**
* **VTTransactionDetails**
* **VTClient**

#### Create VTCustomerDetails

It's representation of customer's information, here is the sample code how to create it.

```
VTAddress *shippingAddress =
[VTAddress addressWithFirstName:<#(NSString *)#>
                       lastName:<#(NSString *)#>
                          phone:<#(NSString *)#>
                        address:<#(NSString *)#>
                           city:<#(NSString *)#>
                     postalCode:<#(NSString *)#>
                    countryCode:<#(NSString *)#>];
    
VTAddress *billingAddress =
[VTAddress addressWithFirstName:<#(NSString *)#>
                       lastName:<#(NSString *)#>
                          phone:<#(NSString *)#>
                        address:<#(NSString *)#>
                           city:<#(NSString *)#>
                     postalCode:<#(NSString *)#>
                    countryCode:<#(NSString *)#>];                        
  
VTCustomerDetails *customerDetails =
[[VTCustomerDetails alloc] initWithFirstName:<#(NSString *)#>
                                    lastName:<#(NSString *)#>
                                       email:<#(NSString *)#>
                                       phone:<#(NSString *)#>
                             shippingAddress:shippingAddress
                              billingAddress:billingAddress]
```
**Important Note:** countryCode need to use 3 digit ISO format e.g. `IDN` for `Indonesia`

#### Create VTItemDetail
It's representation of item that customer want to buy. You need to wrap it in an `NSArray` here is an example.

```
VTItemDetail *itemDetail =
[[VTItemDetail alloc] initWithItemID:<#(NSString *)#>
                                name:<#(NSString *)#>
                               price:<#(NSNumber *)#>
                            quantity:<#(NSNumber *)#>];
NSArray *itemDetails = @[itemDetail];                                    
```

#### Create VTTransactionDetails

It's representation of customer's Order

```
VTTransactionDetails *transactionDetails =
[[VTTransactionDetails alloc] initWithOrderID:<#(NSString *)#>
                               andGrossAmount:<#(NSNumber *)#>];
```

**Important Note:** `grossAmount` need to be the same as `itemDetails` total price, otherwise Veritrans server will reject the transaction.


After the above data ready, you can continue to make a payment transaction.

## 2. Normal Credit Card Transaction

In Credit Card transaction there are two main steps to make transaction

* Generate `token` as representation of credit card
* Charge transaction with generated and valid `token`


### 2.1 Generate Token

Copy and paste the following code to generate `token`.

```
VTCreditCard *card =
[[VTCreditCard alloc] initWithNumber:<#(NSString *)#>
                         expiryMonth:<#(NSString *)#>
                          expiryYear:<#(NSString *)#>
                                 cvv:<#(NSString *)#>];

VTTokenizeRequest *tokenRequest =
[[VTTokenizeRequest alloc] initWithCreditCard:card
                                  grossAmount:transactionDetails.grossAmount
                                       secure:<#(BOOL)#>];

[[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSString *redirectURL, NSError *error) {
    if (error) {
    	//error generating token
    } else {
    	//generate token success
    }
}];
                                       
```
**Note:** If you enable [3D Secure](https://en.wikipedia.org/wiki/3-D_Secure) feature, your token is still in invalid state. To make it valid, you need capture the redirectURL, and open an additional View Controller called VT3DSController. If the end-user puts correct 3D Secure code, then your token be in valid state.

Copy and paste the following code to open `VT3DSController`

```
VT3DSController *secureController =
                [[VT3DSController alloc] initWithToken:token
                                             secureURL:[NSURL URLWithString:redirectURL]];
[secureController showWithCompletion:^(NSError *error) {
    if (error) {
        //3ds error
    } else {
        //token now is valid
    }
}];

```

### 2.2 <a name="charge-normal-transaction"></a>Charge Transaction
After you have a valid `token`, you can continue to the final step of payment and your credit card will be charged. 

Copy and paste the following code to charge transaction. Use your valid `token` as parameter on `VTPaymentCreditCard`.

```
VTPaymentCreditCard *paymentDetails =
[[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureNormal token:<Valid Token>];
    
VTTransaction *transaction =
[[VTTransaction alloc] initWithPaymentDetails:paymentDetails
                           transactionDetails:transactionDetails];
       
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
    if (error) {
    	//transaction error
    } else {
    	//transaction success
    }
}];
```

You will have `result` if the transaction is success, and `error` if the transaction is failed.

## 3. Oneclick Credit Card Transaction

One click transaction offer simple credit card transaction because it only need `token` to charge transaction. The `token` represents the credit card number dan expiry date of the customer's credit card.

### 3.1 <a name="get-oneclick-token"></a>Get Oneclick Token
You can get `token` with two methods:

* Doing Normal credit card transaction with **save token** feature enabled.
* Register the credit card

#### A. Get Token With Normal Credit Card Transaction
When creating `VTPaymentCreditCard` object, make sure it's initialized with feature `VTCreditCardPaymentFeatureNormal` and set `saveToken` to `YES`

```
VTPaymentCreditCard *paymentDetail =
[[VTPaymentCreditCard alloc] initWithFeature:VTCreditCardPaymentFeatureNormal
                                       token:token];
paymentDetail.saveToken = YES;

//next charge transaction process..
```

#### B. Get Token With Register Credit Card 
Register credit card provides simpler way to get the oneclick token

```
VTCreditCard *creditCard =
[[VTCreditCard alloc] initWithNumber:<#(NSString *)#>
                         expiryMonth:<#(NSString *)#>
                          expiryYear:<#(NSString *)#>
                                 cvv:<#(NSString *)#>];
[[VTClient sharedClient] registerCreditCard:creditCard completion:^(VTMaskedCreditCard *maskedCreditCard, NSError *error) {
    if (maskedCreditCard) {
        
    } else {
        //error
    }
}];
```

### 3.2 Charge Transaction With One Click Token
After you have one click `token`, then you can charge credit card transaction with that `token`

```
//create payment detail with oneclick token
VTPaymentCreditCard *paymentDetail =
[[VTPaymentCreditCard alloc] initWithFeature:<#(VTCreditCardPaymentFeature)#>
                                       token:oneClickToken];
    
//create transaction object
VTTransaction *transaction =
[[VTTransaction alloc] initWithPaymentDetails:paymentDetail
                           transactionDetails:<#(VTTransactionDetails *)#>
                              customerDetails:<#(VTCustomerDetails *)#>
                                  itemDetails:<#(NSArray<VTItemDetail *> *)#>];
    
//charge transaction    
[[VTMerchantClient sharedClient] performTransaction:transaction
                                         completion:^(VTTransactionResult *result, NSError *error) {
                                             
                                         }];
```

## 4. Two Click Credit Card Transaction

The **two click token** is basically representation of credit card's information, so you can use that **token** to generate **new token** for charging a transaction.

### 4.1 Get Two Click Token
To get **two click token** you can use the same step as **[getting one click token](#get-oneclick-token)**

### 4.2 Generate New Token
After you've got the **two click `token`**, then you can generate **new token** 

```
//create token request with two click token
VTTokenizeRequest *tokenRequest =
[[[VTTokenizeRequest alloc] initWithTwoClickToken:twoClickToken
                                              cvv:<#(NSString *)#>
                                      grossAmount:<#(NSNumber *)#>]];
                                      
//generate new token for charging a transaction                                      
[[VTClient sharedClient] generateToken:tokenRequest
                            completion:^(NSString *token, NSString *redirectURL, NSError *error) {
                             			
                            }];
```

### 4.3 Charge Transaction

To charge transaction, you can use the same step as **[normal charge transaction](#charge-normal-transaction)**

## 5. VA / Bank Transfer Transaction

### 5.1 Preparing Payment Details
You need to create `paymentDetail` as object of **VTPaymentBankTransfer** and set the bank transfer type with **VTVAType** values

* VTVATypeBCA
* VTVATypeMandiri
* VTVATypePermata
* VTVATypeOther

```
//create payment detail object
VTPaymentBankTransfer *paymentDetails =
[[VTPaymentBankTransfer alloc] initWithBankTransferType:<#(VTVAType)#>];

//create transaction object
VTTransaction *transaction =
[[VTTransaction alloc] initWithPaymentDetails:<#(id<VTPaymentDetails>)#>
                           transactionDetails:<#(VTTransactionDetails *)#>
                              customerDetails:<#(VTCustomerDetails *)#>
                                  itemDetails:<#(NSArray<VTItemDetail *> *)#>];
```

### 5.2 Charge Transaction
Use transaction object to charge the transaction

```
[[VTMerchantClient sharedClient] performTransaction:transaction completion:^(VTTransactionResult *result, NSError *error) {
 	   if (result) {
 	   		//success
 	   } else {
 	   		//error
 	   }
}];
```
