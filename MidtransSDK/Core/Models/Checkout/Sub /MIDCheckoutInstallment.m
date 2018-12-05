//
//  MIDInstallmentOption.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 19/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDCheckoutInstallment.h"

@implementation MIDCheckoutInstallment

- (nonnull NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue: @(self.required) forKey: @"required"];
    [result setValue: self.terms forKey: @"terms"];
    return result;
}

- (instancetype)initWithTerms:(NSDictionary <NSString *, NSArray *> *)terms required:(BOOL)required {
    if (self = [super init]) {
        self.terms = terms;
        self.required = required;
    }
    return self;
}

@end
