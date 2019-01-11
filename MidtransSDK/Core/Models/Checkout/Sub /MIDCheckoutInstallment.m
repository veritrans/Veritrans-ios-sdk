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

- (instancetype)initWithTerms:(NSArray<MIDCheckoutInstallmentTerm *> *)terms required:(BOOL)required {
    if (self = [super init]) {
        self.terms = terms;
        self.required = required;
    }
    return self;
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
