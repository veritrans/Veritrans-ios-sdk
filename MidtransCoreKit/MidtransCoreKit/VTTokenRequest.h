//
//  VTTokenRequest.h
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/10/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTCreditCard.h"

@interface VTTokenRequest : NSObject

@property (nonatomic, readonly) VTCreditCard *creditCard;
@property (nonatomic, readonly) NSString *bank;
@property (nonatomic, readonly) NSNumber *grossAmount;
@property (nonatomic, readonly) BOOL installment;
@property (nonatomic, readonly) NSNumber *installmentTerm;
@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) BOOL twoClick;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) BOOL secure;

+ (instancetype)tokenForNormalTransactionWithCreditCard:(VTCreditCard *)creditCard;

+ (instancetype)tokenForTwoClickTransactionWithToken:(NSString *)token
                                                 cvv:(NSString *)cvv
                                              secure:(BOOL)secure
                                         grossAmount:(NSNumber *)grossAmount;

- (NSDictionary *)dictionaryValue;

@end
