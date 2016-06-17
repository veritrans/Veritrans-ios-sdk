//
//  VTPaymentKlikBCA.h
//  MidtransCoreKit
//
//  Created by Arie on 6/16/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"
@interface VTPaymentKlikBCA : NSObject<VTPaymentDetails>
- (instancetype _Nonnull)initWithKlikBCAUserId:(NSString * _Nonnull)userId;
@end
