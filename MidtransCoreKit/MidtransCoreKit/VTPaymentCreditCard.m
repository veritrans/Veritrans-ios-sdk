//
//  VTPaymentCreditCard.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCreditCard.h"
#import "VTHelper.h"

@interface VTPaymentCreditCard()
@property (nonatomic, readwrite) NSString *tokenId;

@end

@implementation VTPaymentCreditCard

+ (instancetype)paymentForTokenId:(NSString *)tokenId {
    VTPaymentCreditCard *payment = [VTPaymentCreditCard new];
    payment.tokenId = tokenId;
    return payment;
}

- (NSString *)paymentType {
    return @"credit_card";
}

- (NSDictionary *)dictionaryValue {
    return @{@"token_id":_tokenId,
             @"bank":[VTHelper nullifyIfNil:_bank],
             @"installment_term":[VTHelper nullifyIfNil:_installment],
             @"bins":[VTHelper nullifyIfNil:_bins],
             @"type":[VTHelper nullifyIfNil:_type],
             @"save_token_id":_saveTokenId ? @"true":@"false"};
}

@end
