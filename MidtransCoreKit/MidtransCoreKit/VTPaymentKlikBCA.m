//
//  VTPaymentKlikBCA.m
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentKlikBCA.h"
#import "VTConstant.h"
@interface VTPaymentKlikBCA()
@property (nonatomic) NSString *klikBCAUserId;
@end;

@implementation VTPaymentKlikBCA

- (instancetype _Nonnull)initWithKlikBCAUserId:(NSString * _Nonnull)userId {
    if (self = [super init]) {
        self.klikBCAUserId = userId;
    }
    return self;
}

- (NSString *)paymentType {
    return VT_PAYMENT_KLIK_BCA_IDENTIFIER;
}
- (NSDictionary *)dictionaryValue {
    return @{@"user_id" : self.klikBCAUserId,
             @"description" : @"3176440"};
}
@end
