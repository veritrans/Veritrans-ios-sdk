//
//  MIDBCABankTransferResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDBCABankTransferResult.h"

@implementation MIDBCABankTransferResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"bca_expiration"];
        self.vaNumber = [dictionary objectOrNilForKey:@"bca_va_number"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.expiration forKey:@"bca_expiration"];
    [result setValue:self.vaNumber forKey:@"bca_va_number"];
    return result;
}

@end
