//
//  MIDKlikbcaPayment.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 21/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDKlikbcaPayment.h"

@implementation MIDKlikbcaPayment

- (instancetype)initWithUserID:(NSString *)userID {
    if (self = [super init]) {
        self.userID = userID;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type" : @"bca_klikbca",
             @"payment_params" : @{@"user_id":self.userID}
             };
}

@end
