//
//  MIDTokenizeResponse.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 02/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDTokenizeResponse.h"
#import "MIDModelHelper.h"

@implementation MIDTokenizeResponse

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.bank forKey:@"bank"];
    [result setValue:self.maskedCard forKey:@"hash"];
    [result setValue:self.secureURL forKey:@"redirect_url"];
    [result setValue:@(self.statusCode) forKey:@"status_code"];
    [result setValue:self.statusMessage forKey:@"status_message"];
    [result setValue:self.tokenID forKey:@"token_id"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.bank = [dictionary objectOrNilForKey:@"bank"];
        self.maskedCard = [dictionary objectOrNilForKey:@"hash"];
        self.secureURL = [dictionary objectOrNilForKey:@"redirect_url"];
        self.statusCode = [[dictionary objectOrNilForKey:@"status_code"] integerValue];
        self.statusMessage = [dictionary objectOrNilForKey:@"status_message"];
        self.tokenID = [dictionary objectOrNilForKey:@"token_id"];
    }
    return self;
}

@end
