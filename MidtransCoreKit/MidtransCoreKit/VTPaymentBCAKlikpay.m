//
//  VTPaymentBCAKlikpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentBCAKlikpay.h"
#import "VTHelper.h"
#import "VTConstant.h"

@interface VTPaymentBCAKlikpay()
@property (nonatomic) NSString *klikpayDescription;

@property (nonatomic) NSString *token;
@end

@implementation VTPaymentBCAKlikpay

//- (instancetype _Nonnull) initWithDescription:(NSString *_Nonnull)description {
//    if (self = [super init]) {
//        self.klikpayDescription = description;
//    }
//    return self;
//}

- (instancetype _Nonnull) initWithToken:(NSString *_Nonnull)token {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_BCA_KLIKPAY;
}

- (NSDictionary *)dictionaryValue {
    return @{@"transaction_id":self.token};
}

- (NSString *)chargeURL {
    return ENDPOINT_CHARGE_BCA_KLIKPAY;
}

@end
