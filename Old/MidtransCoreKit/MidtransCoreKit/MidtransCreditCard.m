//
//  VTCreditCard.m
//  iossdk-gojek
//
//  Created by Nanang Rafsanjani on 2/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "MidtransCreditCard.h"
#import "MidtransHelper.h"
#import "MidtransConfig.h"
#import "MidtransCreditCardHelper.h"

@interface MidtransCreditCard ()
@property (nonatomic, readwrite) NSString *expiryYear;
@property (nonatomic, readwrite) NSString *expiryMonth;
@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *cvv;
@end

@implementation MidtransCreditCard

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

- (instancetype)initWithNumber:(NSString *)number
                    expiryDate:(NSString *)expiryDate
                           cvv:(NSString *)cvv
{
    if (self = [super init]) {
        self.number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.cvv = cvv;
        NSArray *dates = [expiryDate componentsSeparatedByString:ExpiryDateSeparator];
        NSString *expMonth = dates[0];
        NSString *expYear = dates.count == 2 ? dates[1] : nil;
        self.expiryMonth = expMonth;
        self.expiryYear = expYear;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{@"client_key":[CONFIG clientKey],
             @"card_number":[MidtransHelper nullifyIfNil:self.number],
             @"card_exp_month":[MidtransHelper nullifyIfNil:self.expiryMonth],
             @"card_exp_year":[MidtransHelper nullifyIfNil:self.expiryYear]};
}
@end
