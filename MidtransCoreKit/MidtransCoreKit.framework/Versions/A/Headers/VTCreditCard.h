//
//  VTCreditCard.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VTCreditCardType) {
    VTCreditCardTypeVisa,
    VTCreditCardTypeMasterCard,
    VTCreditCardTypeJCB,
    VTCreditCardTypeUnknown
};


@interface VTCreditCard : NSObject

@property (nonatomic, readonly) NSNumber *expiryYear;
@property (nonatomic, readonly) NSNumber *expiryMonth;
@property (nonatomic, readonly) NSString *number;
@property (nonatomic, readonly) NSString *holder;

+ (instancetype)cardWithNumber:(NSString *)number
                   expiryMonth:(NSNumber *)expiryMonth
                    expiryYear:(NSNumber *)expiryYear
                        holder:(NSString *)holder;

+ (VTCreditCardType)typeWithNumber:(NSString *)number;
+ (NSString *)typeStringWithNumber:(NSString *)number;

@end
