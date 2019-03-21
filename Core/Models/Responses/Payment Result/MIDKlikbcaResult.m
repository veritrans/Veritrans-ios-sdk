//
//  MIDKlikbcaResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 07/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDKlikbcaResult.h"

@implementation MIDKlikbcaResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.approvalCode = [dictionary objectOrNilForKey:@"approval_code"];
        self.expiration = [dictionary objectOrNilForKey:@"bca_klikbca_expire_time"];
        self.redirectURL = [dictionary objectOrNilForKey:@"redirect_url"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.approvalCode forKey:@"approval_code"];
    [result setValue:self.expiration forKey:@"bca_klikbca_expire_time"];
    [result setValue:self.redirectURL forKey:@"redirect_url"];
    return result;
}

@end
