//
//  VTPaymentMandiriClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentMandiriClickpay.h"

@interface VTPaymentMandiriClickpay()
@property (nonatomic) NSString *cardNumber;
@property (nonatomic) NSString *token;
@property (nonatomic) NSNumber *grossAmount;
@end

@implementation VTPaymentMandiriClickpay

- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber grossAmount:(NSNumber *_Nonnull)grossAmount token:(NSString *_Nonnull)token {
    if (self = [super init]) {
        self.cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.grossAmount = grossAmount;
        self.token = token;
    }
    return self;
}

- (NSString *)paymentType {
    return @"mandiri_clickpay";
}

- (NSDictionary *)dictionaryValue {
    return @{@"card_number":_cardNumber,
             @"input1":[VTMandiriClickpayHelper generateInput1FromCardNumber:_cardNumber],
             @"input2":[VTMandiriClickpayHelper generateInput2FromGrossAmount:_grossAmount],
             @"input3":[VTMandiriClickpayHelper generateInput3],
             @"token":_token};
}

@end
