//
//  MIDPromoOption.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDPromoOption.h"

@implementation MIDPromoOption

- (instancetype)initWithID:(NSString *)promoID discountedGrossAmount:(NSNumber *)grossAmount {
    if (self = [super init]) {
        self.promoID = promoID;
        self.discountedGrossAmount = grossAmount;
    }
    return self;
}

- (nonnull NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue: self.promoID forKey: @"promo_id"];
    [result setValue: self.discountedGrossAmount forKey: @"discounted_gross_amount"];
    return result;
}

@end
