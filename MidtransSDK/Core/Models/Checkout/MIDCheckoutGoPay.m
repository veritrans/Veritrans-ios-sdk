//
//  MIDCheckoutGoPay.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 22/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutGoPay.h"

@implementation MIDCheckoutGoPay {
    NSString *_callbackURL;
}

- (NSDictionary *)dictionaryValue {
    NSDictionary *gopay = @{@"enable_callback": @YES,
                            @"callback_url": _callbackURL
                            };
    return @{@"gopay":gopay};
}

- (instancetype)initWithCallbackSchemeURL:(NSString *)callbackURL {
    if (self = [super init]) {
        _callbackURL = callbackURL;
    }
    return self;
}

@end
