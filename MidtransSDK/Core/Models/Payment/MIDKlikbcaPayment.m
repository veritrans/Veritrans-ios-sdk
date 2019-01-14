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
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:@"bca_klikbca" forKey:@"payment_type"];    
    if (self.userID) {
        [result setValue:@{@"user_id":self.userID} forKey:@"payment_params"];
    }
    return result;
}

@end
