//
//  VTPaymentCreditCard.m
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCreditCard.h"
#import "VTHelper.h"
#import "VTConfig.h"

@interface VTPaymentCreditCard()
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, readwrite) VTCreditCardPaymentFeature creditCardPaymentFeature;
@end

@implementation VTPaymentCreditCard

+ (instancetype)paymentUsingFeature:(VTCreditCardPaymentFeature)feature forTokenId:(NSString *)tokenId {
    VTPaymentCreditCard *payment = [VTPaymentCreditCard new];
    payment.creditCardPaymentFeature = feature;
    payment.tokenId = tokenId;
    payment.type = @"authorize";
    return payment;
}

- (NSString *)paymentType {
    return @"credit_card";
}

- (NSDictionary *)dictionaryValue {
    switch (_creditCardPaymentFeature) {
        case VTCreditCardPaymentFeatureNormal:
            return @{@"token_id":_tokenId,
                     @"bank":[VTHelper nullifyIfNil:_bank],
                     @"installment_term":[VTHelper nullifyIfNil:_installmentTerm],
                     @"bins":[VTHelper nullifyIfNil:_bins],
                     @"save_token_id":_saveTokenId ? @"true":@"false"};
        case VTCreditCardPaymentFeatureOneClick:
            return @{@"token_id":_tokenId,
                     @"recurring":@"true"};
        case VTCreditCardPaymentFeatureTwoClick:
            return @{@"token_id":_tokenId};
        case VTCreditCardPaymentFeatureUnknown:
            NSAssert(false, @"Unknown feature credit card payment");
            break;
    }
    
    return nil;
}

@end
