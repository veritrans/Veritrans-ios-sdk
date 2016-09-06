//
//  VTPaymentEpayBRI.h
//  MidtransCoreKit
//
//  Created by Nanang Rafsanjani on 6/14/16.
//  Copyright © 2016 Veritrans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTPaymentDetails.h"

@interface MidtransPaymentEpayBRI : NSObject <VTPaymentDetails>
- (instancetype _Nonnull)initWithToken:(MidtransTransactionTokenResponse *_Nonnull)token;
@end
