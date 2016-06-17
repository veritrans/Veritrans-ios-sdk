//
//  VTCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCreditCard.h"
#import "VTHelper.h"
#import "VTConfig.h"

@interface VTCreditCard ()
@property (nonatomic, readwrite) NSString *expiryYear;
@property (nonatomic, readwrite) NSString *expiryMonth;
@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *cvv;
@end

@implementation VTCreditCard

- (instancetype)initWithNumber:(NSString *)number
                   expiryMonth:(NSString *)expiryMonth
                    expiryYear:(NSString *)expiryYear
                           cvv:(NSString *)cvv {
    if (self = [super init]) {
        self.number = number;
        self.expiryMonth = expiryMonth;
        self.expiryYear = expiryYear;
        self.cvv = cvv;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"client_key":[CONFIG clientKey],
             @"card_number":[VTHelper nullifyIfNil:self.number],
             @"card_exp_month":[VTHelper nullifyIfNil:self.expiryMonth],
             @"card_exp_year":[VTHelper nullifyIfNil:self.expiryYear]};
}
@end
