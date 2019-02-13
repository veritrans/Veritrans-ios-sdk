//
//  MidtransNewCreditCardViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 1/19/17.
//  Copyright © 2017 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@protocol MidtransNewCreditCardViewControllerDelegate <NSObject>
- (void)didDeleteSavedCard;
@end

@interface MidtransNewCreditCardViewController : MidtransUIPaymentController

@property (nonatomic, weak, nullable) id<MidtransNewCreditCardViewControllerDelegate>delegate;
@property (nonatomic,strong) MidtransPromoPromoDetails *promos;
@property (nonatomic)BOOL saveCreditCardOnly;
@property (nonatomic)BOOL noCardHash;
@property (nonatomic, nullable) NSArray <MidtransMaskedCreditCard *>*currentMaskedCards;

- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token
                    paymentMethodName:(MidtransPaymentListModel *_Nonnull)paymentMethod
                    andCreditCardData:(MidtransPaymentRequestV2CreditCard *_Nonnull)creditCard
          andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *_Nonnull)responsePayment;
- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token
                         paymentMethod:(MidtransPaymentListModel *_Nullable)paymentMethod
                            maskedCard:(MidtransMaskedCreditCard *_Nonnull)maskedCard
                            creditCard:(MidtransPaymentRequestV2CreditCard *_Nonnull)creditCard
          andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response *_Nonnull)responsePayment;
@end
