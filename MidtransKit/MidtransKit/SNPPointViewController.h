//
//  SNPPointViewController.h
//  MidtransKit
//
//  Created by Vanbungkring on 3/7/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"

@interface SNPPointViewController : MidtransUIPaymentController
-(instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nullable)token
                  tokenizedCard:(NSString * _Nonnull)tokenizedCard
andCompleteResponseOfPayment:(MidtransPaymentRequestV2Response * _Nonnull)responsePayment;
@end
