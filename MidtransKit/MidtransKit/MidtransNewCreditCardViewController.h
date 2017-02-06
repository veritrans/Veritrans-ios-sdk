//
//  MidtransNewCreditCardViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransNewCreditCardViewController : MidtransUIPaymentController

@property (nonatomic, nullable) NSArray <MidtransPromo *>*promos;

-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token
                    paymentMethodName:(MidtransPaymentListModel *_Nonnull)paymentMethod
                    andCreditCardData:(MidtransPaymentRequestV2CreditCard *_Nonnull)creditCard;
@end
