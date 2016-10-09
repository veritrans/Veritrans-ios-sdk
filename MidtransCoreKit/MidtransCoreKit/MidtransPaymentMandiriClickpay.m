//
//  VTPaymentMandiriClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransPaymentMandiriClickpay.h"
#import "MidtransConstant.h"

@interface MidtransPaymentMandiriClickpay()
@property (nonatomic) NSString *cardNumber;
@property (nonatomic) MidtransTransactionTokenResponse *token;
@property (nonatomic) NSString *clickpayToken;
@property (nonatomic) NSNumber *grossAmount;
@end

@implementation MidtransPaymentMandiriClickpay

- (instancetype _Nonnull)initWithCardNumber:(NSString *_Nonnull)cardNumber clickpayToken:(NSString *_Nonnull)clickpayToken {
    if (self = [super init]) {
        self.cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.clickpayToken = clickpayToken;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_MANDIRI_CLICKPAY,
             @"payment_params":@{@"mandiri_card_no":self.cardNumber,
                                 @"input3":[MidtransMandiriClickpayHelper generateInput3],
                                 @"token_response":self.clickpayToken}};
}

@end
