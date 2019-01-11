//
//  MIDCheckoutInstallmentTerm.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDCheckoutInstallmentTerm.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutInstallmentTerm

- (instancetype)initWithBank:(MIDAcquiringBank)bank terms:(NSArray<NSNumber *> *)terms {
    if (self = [super init]) {
        self.bank = bank;
        self.terms = terms;
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.terms forKey:[NSString nameOfBank:self.bank]];
    return result;
}

@end
