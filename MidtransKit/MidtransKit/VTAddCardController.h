//
//  VTAddCardController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 2/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidtransUIPaymentController.h"


@protocol VTAddCardControllerDelegate;

@interface VTAddCardController : MidtransUIPaymentController

@property (nonatomic, assign, nonnull) id<VTAddCardControllerDelegate>delegate;

-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token
                    paymentMethodName:(MidtransPaymentListModel *_Nonnull)paymentMethod
                    andCreditCardData:(MidtransPaymentRequestV2CreditCard *_Nonnull)creditCard;

@end

@protocol VTAddCardControllerDelegate <NSObject>

- (void)viewController:(VTAddCardController *_Nonnull)viewController didRegisterCard:(MidtransMaskedCreditCard *_Nonnull)registeredCard;
@end
