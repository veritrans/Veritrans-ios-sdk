//
//  SNPPointViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface SNPPointViewController : MidtransUIPaymentController
@property (nonatomic, nullable) NSArray <MidtransMaskedCreditCard *>*currentMaskedCards;
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
                            savedCard:(BOOL)savedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment;
@end
