//
//  VTPaymentKlikBCA.m
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentKlikBCA.h"
#import "MidtransConstant.h"

@interface MidtransPaymentKlikBCA()
@property (nonatomic) NSString *klikBCAUserId;
@end;

@implementation MidtransPaymentKlikBCA

- (instancetype _Nonnull)initWithKlikBCAUserId:(NSString * _Nonnull)userId {
    if (self = [super init]) {
        self.klikBCAUserId = userId;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type" : MIDTRANS_PAYMENT_KLIK_BCA,
             @"payment_params" : @{@"user_id":self.klikBCAUserId}};
}

@end
