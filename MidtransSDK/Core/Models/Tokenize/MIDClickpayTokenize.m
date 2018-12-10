//
//  MIDClickpayTokenRequest.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 06/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDClickpayTokenize.h"
#import "MIDVendor.h"

@interface MIDClickpayTokenize()
@property (nonatomic) NSString *cardNumber;
@end

@implementation MIDClickpayTokenize

- (instancetype)initWithCardNumber:(NSString *)cardNumber {
    if (self = [super init]) {
        self.cardNumber = cardNumber;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"card_number": self.cardNumber,
             @"client_key": [MIDVendor shared].clientKey
             };
}

@end
