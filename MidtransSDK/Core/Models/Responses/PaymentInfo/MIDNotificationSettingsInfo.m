//
//  MIDNotificationSettingsInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDNotificationSettingsInfo.h"
#import "MIDModelHelper.h"

@implementation MIDNotificationSettingsInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.callbackURL forKey:@"callback_url"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.callbackURL = [dictionary objectOrNilForKey:@"callback_url"];
    }
    return self;
}

@end
