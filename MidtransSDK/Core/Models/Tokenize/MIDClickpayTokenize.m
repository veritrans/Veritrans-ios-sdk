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
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.cardNumber forKey:@"card_number"];
    [result setValue:[MIDVendor shared].clientKey forKey:@"client_key"];
    return result;
}

@end
