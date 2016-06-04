//
//  VTCreditCardHelper.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCreditCard.h"

typedef NS_ENUM(NSInteger, VTCreditCardType) {
    VTCreditCardTypeVisa,
    VTCreditCardTypeMasterCard,
    VTCreditCardTypeJCB,
    VTCreditCardTypeAmex,
    VTCreditCardTypeUnknown
};

@interface VTCreditCardHelper : NSObject

@end

@interface NSString (CreditCard)

- (VTCreditCardType)creditCardType;
- (NSString *)creditCardName;

@end


@interface VTCreditCard (Validation)
- (BOOL)isValidCreditCard:(NSError **)error;
@end