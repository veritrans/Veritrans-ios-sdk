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

@implementation MIDCreditCardTokenize

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    [result setValue:[MIDVendor shared].clientKey forKey:@"client_key"];
    [result setValue:self.cardNumber forKey:@"card_number"];
    [result setValue:self.cardCVV forKey:@"card_cvv"];
    [result setValue:self.cardExpMonth forKey:@"card_exp_month"];
    [result setValue:self.cardExpYear forKey:@"card_exp_year"];
    [result setValue:[NSString nameOfBank:self.bank] forKey:@"bank"];
    [result setValue:@(self.secure) forKey:@"secure"];
    [result setValue:self.grossAmount forKey:@"gross_amount"];
    [result setValue:self.installmentTerm forKey:@"installment_term"];
    [result setValue:self.tokenID forKey:@"token_id"];
    [result setValue:[NSString nameOfCreditCardTransactionType:self.type] forKey:@"type"];
    [result setValue:@(self.point) forKey:@"point"];
    
    return result;
}

@end
