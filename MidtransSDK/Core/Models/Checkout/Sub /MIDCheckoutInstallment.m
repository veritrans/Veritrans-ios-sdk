//
//  MIDInstallmentOption.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutInstallment.h"
#import "MIDModelHelper.h"

@implementation MIDCheckoutInstallment

+ (instancetype)modelWithTerms:(NSArray<MIDCheckoutInstallmentTerm *> *)terms required:(BOOL)required {
    MIDCheckoutInstallment *obj = [MIDCheckoutInstallment new];
    obj.terms = terms;
    obj.required = required;
    return obj;
}

- (nonnull NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue: [NSString stringFromBool:self.required] forKey: @"required"];
    [result setValue: [self installmentTerms] forKey: @"terms"];
    return result;
}

- (NSDictionary *)installmentTerms {
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (MIDCheckoutInstallmentTerm *term in self.terms) {
        [result addEntriesFromDictionary:term.dictionaryValue];
    }
    return result;
}

@end
