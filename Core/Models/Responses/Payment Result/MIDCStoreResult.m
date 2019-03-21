//
//  MIDCStoreResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCStoreResult.h"

@implementation MIDCStoreResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.store = [dictionary objectOrNilForKey:@"store"];
        self.paymentCode = [dictionary objectOrNilForKey:@"payment_code"];
        
        if ([self.store isEqualToString:@"alfamart"]) {
            self.expiration = [dictionary objectOrNilForKey:@"alfamart_expire_time"];
        } else {
            self.expiration = [dictionary objectOrNilForKey:@"indomaret_expire_time"];
        }        
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    if ([self.store isEqualToString:@"alfamart"]) {
        [result setValue:self.expiration forKey:@"alfamart_expire_time"];
    } else {
        [result setValue:self.expiration forKey:@"indomaret_expire_time"];
    }
    [result setValue:self.paymentCode forKey:@"payment_code"];
    [result setValue:self.store forKey:@"store"];
    return result;
}

@end
