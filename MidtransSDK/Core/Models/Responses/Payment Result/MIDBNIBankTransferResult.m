//
//  MIDBNIBankTransferResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDBNIBankTransferResult.h"

@implementation MIDBNIBankTransferResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"bni_expiration"];
        self.vaNumber = [dictionary objectOrNilForKey:@"bni_va_number"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.expiration forKey:@"bni_expiration"];
    [result setValue:self.vaNumber forKey:@"bni_va_number"];
    return result;
}

@end
