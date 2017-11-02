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
@property (nonatomic) NSString *cardToken;
@property (nonatomic) MidtransTransactionTokenResponse *token;
@property (nonatomic) NSString *clickpayToken;
@property (nonatomic) NSNumber *grossAmount;
@end

@implementation MidtransPaymentMandiriClickpay

-(instancetype)initWithCardToken:(NSString *)cardToken clickpayToken:(NSString *)clickpayToken {
    if (self = [super init]) {
        self.cardToken = cardToken;
        self.clickpayToken = clickpayToken;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"payment_type":MIDTRANS_PAYMENT_MANDIRI_CLICKPAY,
             @"payment_params":@{@"token_id":self.cardToken,
                                 @"input3":[MidtransMandiriClickpayHelper generateInput3],
                                 @"token":self.clickpayToken}};
}

@end
