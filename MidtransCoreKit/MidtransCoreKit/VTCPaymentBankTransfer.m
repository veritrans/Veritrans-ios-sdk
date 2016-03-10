//
//  VTCPaymentBankTransfer.m
//  MidtransCoreKit
//
//  Created by Akbar Taufiq Herlangga on 3/3/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTCPaymentBankTransfer.h"
#import "VTHelper.h"

@interface VTCPaymentBankTransfer()

@property (nonatomic, readwrite) NSString* bankName;

@end

@implementation VTCPaymentBankTransfer

- (instancetype)initWithBankName:(NSString *)bankName {
    if (self = [super init]) {
        self.bankName = bankName;
    }
    
    return self;
}

- (NSString *)paymentType {
    return @"bank_transfer";
}

- (NSDictionary *)dictionaryValue {
    // The format MUST BE compatible with JSON that described in
    // http://docs.veritrans.co.id/en/api/methods.html#bank_transfer_attr
    
    return @{@"bank": [VTHelper nullifyIfNil:_bankName]};
}

@end
