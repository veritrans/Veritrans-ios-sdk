//
//  MIDCreditCardTokenize.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 11/12/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCreditCardTokenize.h"
#import "MIDModelHelper.h"
#import "MIDVendor.h"

@interface MIDCreditCardTokenize()

@end

@implementation MIDCreditCardTokenize

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    [result setValue:[MIDVendor shared].clientKey forKey:@"client_key"];
    
    [result setValue:self.number forKey:@"card_number"];
    [result setValue:self.expMonth forKey:@"card_exp_month"];
    [result setValue:self.expYear forKey:@"card_exp_year"];
    [result setValue:self.tokenID forKey:@"token_id"];
    [result setValue:self.cvv forKey:@"card_cvv"];
    
    if (self.config.installmentTerm > 0) {
        [result setValue:[NSString stringFromBool:YES] forKey:@"installment"];
        [result setValue:@(self.config.installmentTerm) forKey:@"installment_term"];
    }
    [result setValue:self.config.grossAmount forKey:@"gross_amount"];
    [result setValue:[NSString nameOfCurrency:self.config.currency] forKey:@"currency"];
    [result setValue:[NSString nameOfBank:self.config.bank] forKey:@"bank"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.config.type] forKey:@"type"];
    [result setValue:[NSString nameOfChannel:self.config.channel] forKey:@"channel"];
    [result setValue:[NSString stringFromBool:self.config.enable3ds] forKey:@"secure"];
    [result setValue:[NSString stringFromBool:self.config.enablePoint] forKey:@"point"];
    
    return result;
}

@end
