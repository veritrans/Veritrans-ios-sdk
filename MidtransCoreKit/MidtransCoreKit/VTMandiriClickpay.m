//
//  VTMandiriClickpay.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 2/26/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTMandiriClickpay.h"
#import "VTHelper.h"

@interface VTMandiriClickpay()

@property (nonatomic, readwrite) NSString *debitNumber;
@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) NSString *input1;
@property (nonatomic, readwrite) NSString *input2;
@property (nonatomic, readwrite) NSString *input3;
@property (nonatomic, readwrite) NSNumber *transactionAmount;
@end

@implementation VTMandiriClickpay

+ (instancetype)dataWithDebitNumber:(NSString *)debitNumber token:(NSString *)token transactionAmount:(NSNumber *)transactionAmount {
    VTMandiriClickpay *obj = [VTMandiriClickpay new];
    obj.debitNumber = debitNumber;
    obj.token = token;
    obj.transactionAmount = transactionAmount;
    return obj;
}

- (void)setDebitNumber:(NSString *)debitNumber {
    _debitNumber = debitNumber;
    
    NSInteger startIndex = [debitNumber length] - 10;
    _input1 = [debitNumber substringFromIndex:startIndex];
    _input2 = [_transactionAmount stringValue];
    _input3 = [NSString stringWithFormat:@"%i", arc4random_uniform(5)];
}

- (NSDictionary *)requestData {
    return @{@"card_number":[VTHelper nullifyIfNil:_debitNumber],
             @"input1":[VTHelper nullifyIfNil:_input1],
             @"input2":[VTHelper nullifyIfNil:_input2],
             @"input3":[VTHelper nullifyIfNil:_input3],
             @"token":[VTHelper nullifyIfNil:_token]};
}
@end;
