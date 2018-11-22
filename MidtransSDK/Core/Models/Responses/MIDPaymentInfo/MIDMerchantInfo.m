//
//  MIDMerchantInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDMerchantInfo.h"
#import "MIDModelHelper.h"

@implementation MIDMerchantInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.acquiringBanks forKey:@"acquiring_banks"];
    [result setValue:self.enabledPrinciples forKey:@"enabled_principles"];
    [result setValue:self.pointBanks forKey:@"point_banks"];
    [result setValue:self.clientKey forKey:@"client_key"];
    [result setValue:self.merchantID forKey:@"merchant_id"];
    [result setValue:[self.notifSettings dictionaryValue] forKey:@"notification_settings"];
    [result setValue:[self.preference dictionaryValue] forKey:@"preference"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.acquiringBanks = [dictionary objectOrNilForKey:@"acquiring_banks"];
        self.enabledPrinciples = [dictionary objectOrNilForKey:@"enabled_principles"];
        self.pointBanks = [dictionary objectOrNilForKey:@"point_banks"];
        self.clientKey = [dictionary objectOrNilForKey:@"client_key"];
        self.merchantID = [dictionary objectOrNilForKey:@"merchant_id"];
        self.notifSettings = [[MIDNotificationSettingsInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"notification_settings"]];
        self.preference = [[MIDPreferenceInfo alloc] initWithDictionary:[dictionary objectOrNilForKey:@"preference"]];
    }
    return self;
}

@end
