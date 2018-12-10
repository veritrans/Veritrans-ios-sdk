//
//  MIDMandiriBankTransferResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDMandiriBankTransferResult.h"

@implementation MIDMandiriBankTransferResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"billpayment_expiration"];
        self.key = [dictionary objectOrNilForKey:@"bill_key"];
        self.code = [dictionary objectOrNilForKey:@"biller_code"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.expiration forKey:@"billpayment_expiration"];
    [result setValue:self.key forKey:@"bill_key"];
    [result setValue:self.code forKey:@"biller_code"];
    return result;
}

@end
