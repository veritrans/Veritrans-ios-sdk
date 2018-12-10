//
//  MIDPromoInfo.m
//  MidtransSDK
//
//  Created by Nanang Rafsanjani on 10/11/18.
//  Copyright © 2018 Midtrans. All rights reserved.
//

#import "MIDPromoInfo.h"
#import "MIDModelHelper.h"

@implementation MIDPromoInfo

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:self.promos forKey:@"promos"];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.promos = [dictionary objectOrNilForKey:@"promos"];
    }
    return self;
}

@end
