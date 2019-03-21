//
//  MIDCreditCardTokenizer.h
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 26/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDModelEnums.h"
#import "MIDTokenizeConfig.h"
#import "MIDTokenizeResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDCreditCardTokenizer : NSObject

+ (void)tokenizeCardNumber:(NSString *)cardNumber
                       cvv:(NSString *)cvv
               expireMonth:(NSString *)expireMonth
                expireYear:(NSString *)expireYear
                    config:(MIDTokenizeConfig *_Nullable)config
                completion:(void (^)(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error))completion;

+ (void)tokenizeCardToken:(NSString *)cardToken
                      cvv:(NSString *)cvv
                   config:(MIDTokenizeConfig *)config
               completion:(void (^)(MIDTokenizeResponse *_Nullable token, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
