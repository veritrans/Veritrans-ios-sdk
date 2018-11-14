//
//  MIDToken.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDToken.h"
#import "MIDModelHelper.h"

@implementation MIDToken

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.token forKey:@"token"];
    [result setValue:self.redirectURL forKey:@"last_name"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.token = [dictionary objectOrNilForKey:@"token"];
        self.redirectURL = [dictionary objectOrNilForKey:@"redirect_url"];
    }
    return self;
}

@end
