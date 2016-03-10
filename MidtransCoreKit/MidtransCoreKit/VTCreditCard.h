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

@property (nonatomic, readonly) NSString *expiryYear;
@property (nonatomic, readonly) NSString *expiryMonth;
@property (nonatomic, readonly) NSString *number;
@property (nonatomic, readonly) NSString *holder;
@property (nonatomic, readonly) NSString *cvv;

+ (instancetype)cardWithNumber:(NSString *)number
                   expiryMonth:(NSString *)expiryMonth
                    expiryYear:(NSString *)expiryYear
                           cvv:(NSString *)cvv
                        holder:(NSString *)holder;

+ (VTCreditCardType)typeWithNumber:(NSString *)number;
+ (NSString *)typeStringWithNumber:(NSString *)number;

@end
