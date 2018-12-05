//
//  MIDPaymentMethodInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentMethodInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPaymentMethodInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.status forKey:@"status"];
    [result setValue:self.type forKey:@"type"];
    [result setValue:self.category forKey:@"category"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.status = [dictionary objectOrNilForKey:@"status"];
        self.type = [dictionary objectOrNilForKey:@"type"];
        self.category = [dictionary objectOrNilForKey:@"category"];
    }
    return self;
}

@end
