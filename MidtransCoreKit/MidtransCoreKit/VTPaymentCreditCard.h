//
//  VTPaymentCreditCard.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "VTPayment.h"
#import "VTCreditCard.h"



@interface VTPaymentCreditCard : VTPayment

@property (nonatomic, assign) BOOL secure;
@property (nonatomic, strong) NSString *bank;

- (void)payWithCard:(VTCreditCard *)card cvv:(NSString *)cvv callback:(void(^)(id response, NSError *error))callback;

@end
