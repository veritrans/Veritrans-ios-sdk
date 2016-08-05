//
//  VTVAController.h
//  MidtransKit
//
//  Created by Nanang Rafsanjani on 3/1/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransCoreKit/VTPaymentBankTransfer.h>

#import "VTPaymentController.h"
#import "VTClassHelper.h"

@interface VTVAController : VTPaymentController

- (instancetype)initWithVAType:(VTVAType)type customerDetails:(VTCustomerDetails *)customerDetails itemDetails:(NSArray<VTItemDetail*>*)itemDetails transactionDetails:(VTTransactionDetails*)transactionDetails;

@end
