//
//  MIDCreditCardModel.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 05/03/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDCreditCardModel.h"
#import "MIDCreditCardHelper.h"
#import "MidtransSDK.h"
#import "MIDVendor.h"

@interface MIDCreditCardModel ()
@property (nonatomic, readwrite) NSString *expiryYear;
@property (nonatomic, readwrite) NSString *expiryMonth;
@property (nonatomic, readwrite) NSString *number;
@property (nonatomic, readwrite) NSString *cvv;
@end

@implementation MIDCreditCardModel

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
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:[MIDVendor shared].clientKey forKey:@"client_key"];
    [result setValue:self.number forKey:@"card_number"];
    [result setValue:self.expiryMonth forKey:@"card_exp_month"];
    [result setValue:self.expiryYear forKey:@"card_exp_year"];
    return result;
}
@end

