//
//  MIdtransPaymentGCI.m
//  MidtransCoreKit
//
//  Created by Vanbungkring on 12/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MIdtransPaymentGCI.h"

@interface MIdtransPaymentGCI()
@property (nonatomic) NSString *cardNumber;
@property (nonatomic) MidtransTransactionTokenResponse *token;
@property (nonatomic) NSString *password;
@end

@implementation MIdtransPaymentGCI

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_GCI,
             @"payment_params":@{@"card_number":self.cardNumber,
                                 @"pin":self.password}};
}
- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber password:(NSString *_Nonnull)password {
    if (self = [super init]) {
        self.cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.password = password;
    }
    return self;
}
@end
