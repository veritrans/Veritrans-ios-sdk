//
//  VTMerchantAuth.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 3/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMerchantAuth.h"

@interface VTMerchantAuth()
@property (nonatomic) NSString *key;
@property (nonatomic) id value;
@end

@implementation VTMerchantAuth

- (id)initWithKey:(NSString *)key value:(id)value {
    self = [super init];
    if (self) {
        _key = key;
        _value = value;
    }
    return self;
}

- (NSDictionary *)dictinaryValue {
    return @{_key:_value};
}

@end
