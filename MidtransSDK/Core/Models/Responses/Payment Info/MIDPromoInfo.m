//
//  MIDPromoInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPromoInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPromo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.bins = [self formatBins:[dictionary objectOrNilForKey:@"bins"]];
        self.discountType = [dictionary objectOrNilForKey:@"discount_type"];
        self.promoID = [dictionary objectOrNilForKey:@"id"];
        self.discountedGrossAmount = [dictionary objectOrNilForKey:@"discounted_gross_amount"];
        self.calculatedDiscountAmount = [dictionary objectOrNilForKey:@"calculated_discount_amount"];
        self.paymentTypes = [dictionary objectOrNilForKey:@"payment_types"];
        self.name = [dictionary objectOrNilForKey:@"name"];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.bins forKey:@"bins"];
    [result setValue:self.discountType forKey:@"discount_type"];
    [result setValue:self.promoID forKey:@"id"];
    [result setValue:self.discountedGrossAmount forKey:@"discounted_gross_amount"];
    [result setValue:self.calculatedDiscountAmount forKey:@"calculated_discount_amount"];
    [result setValue:self.paymentTypes forKey:@"payment_types"];
    [result setValue:self.name forKey:@"name"];
    return result;
}

- (NSArray *)formatBins:(NSArray *)bins {
    NSMutableArray *result = [NSMutableArray new];
    [bins enumerateObjectsUsingBlock:^(NSString *bin, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:bin];
    }];
    return result;
}

@end

@implementation MIDPromoInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[self.promos dictionaryValues] forKey:@"promos"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.promos = [[dictionary objectOrNilForKey:@"promos"] mapToArray:[MIDPromo class]];
    }
    return self;
}

@end
