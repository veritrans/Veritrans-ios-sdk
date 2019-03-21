//
//  MIDVirtualAccountPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDBankTransferPayment.h"
#import "MIDModelHelper.h"

@implementation MIDBankTransferPayment

- (instancetype)initWithType:(MIDBankTransferType)type email:(NSString *)email {
    if (self = [super init]) {
        self.type = type;
        self.email = email;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:[NSString typeOfVirtualAccount:self.type] forKey:@"payment_type"];
    if (self.email) {
        [result setValue:@{@"email":self.email} forKey:@"customer_details"];
    }
    return result;
}

@end
