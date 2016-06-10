//
//  VTTwoClickController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/4/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/MidtransCoreKit.h>

#import "VTPaymentController.h"
#import "VTCCBackView.h"

@interface VTTwoClickController : VTPaymentController
@property (weak, nonatomic) IBOutlet VTCCBackView *backView;

- (instancetype)initWithCustomerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail *> *)itemDetails transactionDetails:(VTTransactionDetails *)transactionDetails maskedCard:(VTMaskedCreditCard *)maskedCard;

@end
