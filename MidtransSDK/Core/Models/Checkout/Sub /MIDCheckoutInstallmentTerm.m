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

+ (instancetype)modelWithBank:(MIDAcquiringBank)bank terms:(NSArray<NSNumber *> *)terms {
    MIDCheckoutInstallmentTerm *obj = [MIDCheckoutInstallmentTerm new];
    obj.bank = bank;
    obj.terms = terms;
    return obj;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setValue:self.terms forKey:[NSString nameOfBank:self.bank]];
    return result;
}

@end
