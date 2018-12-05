
//
//  MIDPermataBankTransferResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPermataBankTransferResult.h"

@implementation MIDPermataBankTransferResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"permata_expiration"];
        self.vaNumber = [dictionary objectOrNilForKey:@"permata_va_number"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.expiration forKey:@"permata_expiration"];
    [result setValue:self.vaNumber forKey:@"permata_va_number"];
    return result;
}

@end
