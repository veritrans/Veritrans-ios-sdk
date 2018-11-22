//
//  MIDAkulakuPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDGeneralPayment.h"
#import "MIDModelHelper.h"

@implementation MIDGeneralPayment

- (instancetype)initWithType:(MIDGeneralPaymentType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type": [NSString typeOfPayment:self.type]};
}

@end
