//
//  VTPaymentCStore.m
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentCStore.h"

@interface VTPaymentCStore()
@property (nonatomic) NSString *storeName;
@property (nonatomic) NSString *message;
@end

@implementation VTPaymentCStore

- (instancetype _Nonnull)initWithStoreName:(NSString *_Nonnull)storeName message:(NSString *_Nonnull)message {
    if (self = [super init]) {
        self.storeName = storeName;
        self.message = message;
    }
    return self;
}

- (NSString *)paymentType {
    return @"cstore";
}

- (NSDictionary *)dictionaryValue {
    return @{@"store":_storeName,
             @"message":_message};
}

@end
