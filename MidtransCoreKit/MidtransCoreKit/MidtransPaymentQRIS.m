//
//  MidtransPaymentQRIS.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 11/28/17.
//  Copyright © 2017 Midtrans. All rights reserved.
//

#import "MidtransPaymentQRIS.h"

@interface MidtransPaymentQRIS()
@property (nonatomic) NSString *acquirer;
@end

@implementation MidtransPaymentQRIS
- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_QRIS,
             @"payment_params": @{
                     @"acquirer": @[self.acquirer]
             }
    };
}

- (instancetype _Nonnull)initWithAcquirer:(NSString *_Nonnull)acquirer {
    if (self = [super init]) {
        self.acquirer = acquirer;
    }
    return self;
}
@end
