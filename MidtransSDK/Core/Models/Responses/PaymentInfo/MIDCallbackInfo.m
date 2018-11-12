//
//  MIDCallbackInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCallbackInfo.h"
#import "MIDModelHelper.h"

@implementation MIDCallbackInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.error forKey:@"error"];
    [result setValue:self.finish forKey:@"finish"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.error = [dictionary objectOrNilForKey:@"error"];
        self.finish = [dictionary objectOrNilForKey:@"finish"];
    }
    return self;
}

@end
