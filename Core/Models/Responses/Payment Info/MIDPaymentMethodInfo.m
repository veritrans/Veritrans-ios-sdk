//
//  MIDPaymentMethodInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPaymentMethodInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPaymentMethodInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[self stringStatus:self.isActive] forKey:@"status"];
    [result setValue:[NSString stringOfPaymentMethod:self.type] forKey:@"type"];
    [result setValue:[NSString stringOfPaymentCategory:self.category] forKey:@"category"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.isActive = [self statusFromString:[dictionary objectOrNilForKey:@"status"]];
        self.type = [[dictionary objectOrNilForKey:@"type"] paymentMethod];
        self.category = [[dictionary objectOrNilForKey:@"category"] paymentCategory];
    }
    return self;
}

- (NSString *)stringStatus:(BOOL)status {
    if (status) {
        return @"up";
    } else {
        return @"down";
    }
}

- (BOOL)statusFromString:(NSString *)status {
    if ([status isEqualToString:@"up"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
