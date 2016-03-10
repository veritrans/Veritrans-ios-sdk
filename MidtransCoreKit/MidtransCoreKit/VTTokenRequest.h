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
@property (nonatomic, readonly) BOOL secure;
@property (nonatomic, readonly) NSNumber *grossAmount;
@property (nonatomic, readonly) BOOL installment;
@property (nonatomic, readonly) NSNumber *installmentTerm;
@property (nonatomic, readonly) NSString *tokenId;
@property (nonatomic, readonly) BOOL twoClick;
@property (nonatomic, readonly) NSString *type;

+ (instancetype)tokenForNormalTransactionWithCreditCard:(VTCreditCard *)creditCard;

+ (instancetype)tokenFor3DSecureTransactionWithCreditCard:(VTCreditCard *)creditCard
                                                     bank:(NSString *)bank
                                                   secure:(BOOL)secure
                                              grossAmount:(NSNumber *)grossAmount;

@end
