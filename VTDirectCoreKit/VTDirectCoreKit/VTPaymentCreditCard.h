//
//  VTPaymentCreditCard.h
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "VTPayment.h"
#import "VTCreditCard.h"



@interface VTPaymentCreditCard : VTPayment

+ (instancetype)paymentWithCard:(VTCreditCard *)card
                           bank:(NSString *)bank
                         secure:(BOOL)secure
                           user:(VTUser *)user
                          items:(NSArray *)items;

- (void)payWithCallback:(void(^)(id response, NSError *error))callback;

@end
