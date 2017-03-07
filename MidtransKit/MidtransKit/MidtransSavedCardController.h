//
//  MidtransSavedCardController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/2/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIPaymentController.h"


@interface MidtransSavedCardController : MidtransUIPaymentController
@property (nonatomic) NSArray <MidtransPromo *>*promos;
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
            andCreditCardData:(MidtransPaymentRequestV2CreditCard *)creditCard
 andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *)responsePayment;
@end
