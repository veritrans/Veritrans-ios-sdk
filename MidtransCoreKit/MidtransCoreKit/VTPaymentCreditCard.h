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

+ (instancetype)paymentWithUser:(VTUser *)user amount:(NSNumber *)amount creditCard:(VTCreditCard *)creditCard;

- (void)payWithCVV:(NSString *)cvv callback:(void (^)(id, NSError *))callback;

@end
