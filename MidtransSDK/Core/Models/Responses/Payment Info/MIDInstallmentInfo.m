//
//  MIDInstallmentInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 03/01/19.
//  Copyright © 2019 Midtrans. All rights reserved.
//

#import "MIDInstallmentInfo.h"
#import "MIDModelHelper.h"

@implementation MIDInstallmentInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:@(self.required) forKey:@"required"];
    [result setValue:self.terms forKey:@"terms"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.required = [[dictionary objectOrNilForKey:@"required"] boolValue];
        self.terms = [dictionary objectOrNilForKey:@"terms"];
    }
    return self;
}

@end
