//
//  VTPaymentKlikBCA.m
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import "VTPaymentKlikBCA.h"

@implementation VTPaymentKlikBCA

- (NSString *)paymentType {
    return @"bca_klikbca";
}
- (NSDictionary *)dictionaryValue {
    return @{@"user_id":@"veritranss1012",
             @"description":@"3176440"};
}
@end
