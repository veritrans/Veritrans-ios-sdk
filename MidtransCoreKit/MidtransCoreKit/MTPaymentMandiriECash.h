//
//  VTPaymentMandiriECash.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/13/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPaymentDetails.h"

@interface MTPaymentMandiriECash : NSObject<MTPaymentDetails>
- (instancetype _Nonnull)initWithToken:(MTTransactionTokenResponse * _Nonnull)token;
@end
