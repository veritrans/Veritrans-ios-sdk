//
//  VTPaymentBCAKlikpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentBCAKlikpay.h"
#import "VTHelper.h"

@interface VTPaymentBCAKlikpay()
@property (nonatomic) NSString *klikpayDescription;
@end

@implementation VTPaymentBCAKlikpay

- (instancetype _Nonnull) initWithDescription:(NSString *_Nonnull)description {
    if (self = [super init]) {
        self.klikpayDescription = description;
    }
    return self;
}
- (NSString *)paymentType {
    return VT_PAYMENT_BCA_KLIKPAY;
}
- (NSDictionary *)dictionaryValue {
    return @{@"type":@1,
             @"description":_klikpayDescription};
}

@end
