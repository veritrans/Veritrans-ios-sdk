//
//  MIDPreferenceInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPreferenceInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPreferenceInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.colorScheme forKey:@"color_scheme"];
    [result setValue:self.colorSchemeURL forKey:@"color_scheme_url"];
    [result setValue:self.displayName forKey:@"display_name"];
    [result setValue:self.errorURL forKey:@"error_url"];
    [result setValue:self.finishURL forKey:@"finish_url"];
    [result setValue:self.trackingCodeGA forKey:@"ga_tracking_code"];
    [result setValue:self.locale forKey:@"locale"];
    [result setValue:self.otherVAProcessor forKey:@"other_va_processor"];
    [result setValue:self.pendingURL forKey:@"pending_url"];
    [result setValue:self.vtwebVersion forKey:@"vtweb_version"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.colorScheme = [dictionary objectOrNilForKey:@"color_scheme"];
        self.colorSchemeURL = [dictionary objectOrNilForKey:@"color_scheme_url"];
        self.displayName = [dictionary objectOrNilForKey:@"display_name"];
        self.errorURL = [dictionary objectOrNilForKey:@"error_url"];
        self.finishURL = [dictionary objectOrNilForKey:@"finish_url"];
        self.trackingCodeGA = [dictionary objectOrNilForKey:@"ga_tracking_code"];
        self.locale = [dictionary objectOrNilForKey:@"locale"];
        self.otherVAProcessor = [dictionary objectOrNilForKey:@"other_va_processor"];
        self.pendingURL = [dictionary objectOrNilForKey:@"pending_url"];
        self.vtwebVersion = [dictionary objectOrNilForKey:@"vtweb_version"];
    }
    return self;
}

@end
