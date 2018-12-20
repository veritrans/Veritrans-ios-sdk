//
//  MIDCreditCardCharge.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 11/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDCreditCardResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCreditCardCharge : NSObject

+ (void)normalWithToken:(NSString *)token
             cardNumber:(NSString *)cardNumber
                    cvv:(NSString *)cvv
            expireMonth:(NSString *)expireMonth
             expireYear:(NSString *)expireYear
                   bank:(NSString *_Nullable)bank
             completion:(void (^)(MIDCreditCardResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
