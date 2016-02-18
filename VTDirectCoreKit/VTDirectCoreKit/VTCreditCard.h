//
//  VTCreditCard.h
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VTCreditCardType) {
    VTCreditCardTypeVisa,
    VTCreditCardTypeMasterCard,
    VTCreditCardTypeDinersClub,
    VTCreditCardTypeAmex,
    VTCreditCardTypeDiscover,
    VTCreditCardTypeJCB,
    VTCreditCardTypeUnknown
};


@interface VTCreditCard : NSObject

@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly) NSNumber *cvv;
@property (nonatomic, readonly) NSNumber *expiryYear;
@property (nonatomic, readonly) NSNumber *expiryMonth;
@property (nonatomic, readonly) NSString *type;

+ (instancetype)cardWithNumber:(NSNumber *)number expiryMonth:(NSNumber *)expiryMonth expiryYear:(NSNumber *)expiryYear cvv:(NSNumber *)cvv;

@end
