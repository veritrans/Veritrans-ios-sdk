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
@property (nonatomic) NSNumber *miscFee;
@property (nonatomic) NSNumber *type;
@end

@implementation VTPaymentBCAKlikpay

- (NSString *)paymentType {
    return @"bca_klikpay";
}
- (NSDictionary *)dictionaryValue {
    return @{@"type":@1,//[VTHelper nullifyIfNil:_type],
             @"misc_fee":@10,//[VTHelper nullifyIfNil:_miscFee],
             @"description":@"description content"};//[VTHelper nullifyIfNil:_klikpayDescription]};
}

@end
