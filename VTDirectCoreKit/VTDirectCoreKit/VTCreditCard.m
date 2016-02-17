//
//  VTCreditCard.m
//  VTDirectCoreKit
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCard.h"

@interface VTCreditCard ()
@property (nonatomic, readwrite) NSNumber *number;
@property (nonatomic, readwrite) NSNumber *cvv;
@property (nonatomic, readwrite) NSString *bank;
@property (nonatomic, readwrite) NSNumber *grossAmount;
@property (nonatomic, readwrite) NSNumber *expiryMonth;
@property (nonatomic, readwrite) NSNumber *expiryYear;
@property (nonatomic, readwrite) BOOL secure;
@end

@implementation VTCreditCard

+ (instancetype)cardWithNumber:(NSNumber *)number
                   expiryMonth:(NSNumber *)expiryMonth
                    expiryYear:(NSNumber *)expiryYear
                           cvv:(NSNumber *)cvv {
    VTCreditCard *card = [[VTCreditCard alloc] init];
    card.number = number;
    card.expiryMonth = expiryMonth;
    card.expiryYear = expiryYear;
    card.cvv = cvv;
    return card;
}

@end
