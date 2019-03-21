//
//  MIDWebPaymentResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDWebPaymentResult.h"

@implementation MIDWebPaymentResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.redirectURL = [dictionary objectOrNilForKey:@"redirect_url"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.redirectURL forKey:@"redirect_url"];
    return result;
}

@end
