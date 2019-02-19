//
//  MIDIndomaretResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDIndomaretResult.h"

@implementation MIDIndomaretResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"indomaret_expire_time"];
        self.paymentCode = [dictionary objectOrNilForKey:@"payment_code"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.expiration forKey:@"indomaret_expire_time"];
    [result setValue:self.paymentCode forKey:@"payment_code"];
    return result;
}

@end
