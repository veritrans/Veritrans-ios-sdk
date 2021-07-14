//
//  VTPaymentGeneralViewController.h
//  MidtransKit
//
//  Created by Arie on 6/18/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransUIPaymentController.h"
#import <MidtransCoreKit/MidtransCoreKit.h>

@interface MIDUobViewController : MidtransUIPaymentController
@property (nonatomic, nullable) NSString *uobSelectedOptionTitle;
@property (nonatomic, nullable) NSString *uobSelectedOption;

- (instancetype)initWithToken:(MidtransTransactionTokenResponse *)token
            paymentMethodName:(MidtransPaymentListModel *)paymentMethod
                     merchant:(MidtransPaymentRequestV2Merchant *)merchant;
@end
