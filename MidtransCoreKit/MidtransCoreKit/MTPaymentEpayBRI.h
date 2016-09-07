//
//  VTPaymentEpayBRI.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPaymentDetails.h"

@interface MTPaymentEpayBRI : NSObject <MTPaymentDetails>
- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse *_Nonnull)token;
@end
