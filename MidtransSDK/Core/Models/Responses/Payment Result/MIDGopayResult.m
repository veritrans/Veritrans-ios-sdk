//
//  MIDGopayResult.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 04/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDGopayResult.h"

@implementation MIDGopayResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.expiration = [dictionary objectOrNilForKey:@"gopay_expiration"];
        self.expirationRaw = [dictionary objectOrNilForKey:@"gopay_expiration_raw"];
        self.qrCodeURL = [dictionary objectOrNilForKey:@"qr_code_url"];
        self.deepLinkURL = [dictionary objectOrNilForKey:@"deeplink_url"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [result setValue:self.deepLinkURL forKey:@"deeplink_url"];
    [result setValue:self.qrCodeURL forKey:@"qr_code_url"];
    [result setValue:self.expiration forKey:@"gopay_expiration"];
    [result setValue:self.expiration forKey:@"gopay_expiration_raw"];
    return result;
}

@end
