```
//Get saved card
[[VTMerchantClient sharedClient] fetchMaskedCardsWithCompletion:^(NSArray *maskedCards, NSError *error) {
	//maskedCards is array of VTMaskedCreditCard
}];

//Delete saved card
[[VTMerchantClient sharedClient] deleteMaskedCard:<VTMaskedCreditCard> completion:^(BOOL success, NSError *error) {

}];

//REGISTERING THE CREDIT CARD
VTCreditCard *creditCard = [VTCreditCard cardWithNumber:<card number> expiryMonth:<expiry month> expiryYear:<expiry year> cvv:<cvv number>];    
[[VTClient sharedClient] registerCreditCard:creditCard completion:^(VTMaskedCreditCard *registeredCard, NSError *error) {
	
}];


//PERFORMING ONECLICK PAYMENT
VTPaymentCreditCard *paymentDetail = [VTPaymentCreditCard paymentForTokenId:<savedTokenId fromm VTMaskedCreditCard>];
VTCTransactionDetails *transactionDetail = [[VTCTransactionDetails alloc] initWithGrossAmount:<transaction amount>];
VTCTransactionData *transactionData = [[VTCTransactionData alloc] initWithpaymentDetails:paymentDetail
															 transactionDetails:transactionDetail
																customerDetails:<VTCustomerDetails object>
																	itemDetails:<array of VTItem>];

[[VTMerchantClient sharedClient] performCreditCardTransaction:transactionData completion:^(VTPaymentResult *result, NSError *error) {
 
}];


// PERFORMING TWO CLICK PAYMENT

//first generate token id using savedTokenId from VTMaskedCreditCard
VTTokenRequest *tokenRequest = [VTTokenRequest tokenForTwoClickTransactionWithToken:<savedTokenId from VTMaskedCreditCard>
                                                                                    cvv:<cvv number>
                                                                                 secure:<activate 3D secure transaction or not>
                                                                            grossAmount:<transaction amount>];    
[[VTClient sharedClient] generateToken:tokenRequest completion:^(NSString *token, NSError *error) {

}];

//then use that token to performing transaction
VTPaymentCreditCard *paymentDetail = [VTPaymentCreditCard paymentForTokenId:<token>];
VTCTransactionDetails *transactionDetail = [[VTCTransactionDetails alloc] initWithGrossAmount:<transaction amount>];
VTCTransactionData *transData = [[VTCTransactionData alloc] initWithpaymentDetails:paymentDetail
																transactionDetails:transactionDetail
																   customerDetails:<VTCustomerDetails object>
																	   itemDetails:<array of VTItem>];

[[VTMerchantClient sharedClient] performCreditCardTransaction:transData completion:^(VTPaymentResult *result, NSError *error) {
	
}];
```