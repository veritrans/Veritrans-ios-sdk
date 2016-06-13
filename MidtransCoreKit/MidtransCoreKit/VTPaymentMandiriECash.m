//
//  VTPaymentMandiriECash.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentMandiriECash.h"

@interface VTPaymentMandiriECash()
@property (nonatomic) NSString *ecashDescription;
@end

@implementation VTPaymentMandiriECash

- (instancetype _Nonnull)initWithDescription:(NSString * _Nonnull)description {
    if (self = [super init]) {
        self.ecashDescription = description;
    }
    return self;
}
- (NSString *)paymentType {
    return @"mandiri_ecash";
}
- (NSDictionary *)dictionaryValue {
    return @{@"description":_ecashDescription};
}

@end
