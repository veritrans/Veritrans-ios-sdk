//
//  SNPPointViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface SNPPointViewController : MidtransUIPaymentController
@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)NSString *redirectURL;

@property (nonatomic, nullable) NSArray <MidtransMaskedCreditCard *>*currentMaskedCards;
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        paymentMethod:(MidtransPaymentListModel *_Nullable)paymentMethod
                        tokenizedRequst:(MidtransTokenizeRequest* _Nonnull)tokenizedRequest
                            savedCard:(BOOL)savedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment;

-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                        paymentMethod:(MidtransPaymentListModel *_Nullable)paymentMethod
                        tokenizedCard:(NSString * _Nonnull)tokenizedCard
                            savedCard:(BOOL)savedCard
         andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment;
@end
