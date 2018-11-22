//
//  MIDVirtualAccountPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDVirtualAccountPayment.h"
#import "MIDModelHelper.h"

@implementation MIDVirtualAccountPayment

- (instancetype)initWithType:(MIDVirtualAccountType)type email:(NSString *)email {
    if (self = [super init]) {
        self.type = type;
        self.email = email;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":[NSString typeOfVirtualAccount:self.type],
             @"customer_details":@{@"email":self.email}
             };
}

@end
