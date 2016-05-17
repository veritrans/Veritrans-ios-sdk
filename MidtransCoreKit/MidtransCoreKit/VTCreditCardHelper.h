//
//  VTCreditCardHelper.h
//  iossdk-gojek
//
//  Created by Akbar Taufiq Herlangga on 3/23/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VTCreditCardType) {
    VTCreditCardTypeVisa,
    VTCreditCardTypeMasterCard,
    VTCreditCardTypeJCB,
    VTCreditCardTypeUnknown
};

@interface VTCreditCardHelper : NSObject

+ (VTCreditCardType)typeWithNumber:(NSString *)number;
+ (NSString *)typeStringWithNumber:(NSString *)number;

@end
