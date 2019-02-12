//
//  VTPaymentGeneralViewController.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MidtransUIPaymentGeneralViewController : MidtransUIPaymentController
- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant;
@end
